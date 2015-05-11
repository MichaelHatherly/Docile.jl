["Collect docstrings from files."]

"""
Temporary container used for docstring processing. Not the final storage.
"""
type Output
    rawstrings :: ObjectIdDict
    metadata   :: ObjectIdDict

    Output() = new(ObjectIdDict(), ObjectIdDict())
end

"""
Extract all docstrings and basic metadata (file, line, & code) from a module.
"""
function docstrings(m::ModuleData)
    # Handle `@document` and `@docstrings` argument lists
    isdefined(m.modname, :__DOCILE_ARGS__) && extract_args!(m)
    # Handle modules documented using `@doc`. Can't have both types in one.
    isdefined(m.modname, :__DOCILE_STRINGS__) && return extract_atdocs(m)

    # Handle plain docstring documented modules.
    output = Output()
    rexpr  = findmodule(m.parsed[m.rootfile], m.modname)
    process!(output, m, m.rootfile, rexpr.args[end])
    for file in m.files
        process!(output, m, file, m.parsed[file])
    end
    output.rawstrings, output.metadata # Unpack the results.
end

extract_args!(m::ModuleData) =
    merge!(m.metadata, m.modname.__DOCILE_ARGS__)

extract_atdocs(m::ModuleData) =
    (m.modname.__DOCILE_STRINGS__, m.modname.__DOCILE_METADATA__)

"Extract all docstrings and metadata from a given file"; :process!

process!(output, moduledata, file, expr) = cd(dirname(file)) do
    process!(output, moduledata, State(moduledata.modname), file, expr)
end
function process!(output, moduledata, state, file, expr::Expr)
    # Don't search through non-toplevel expressions.
    skipexpr(expr) && return output
    # Add type parameters to the scope for inner constructor usage when in a type.
    scoped(state, expr) do
        for n in 1:(length(expr.args) - 3)
            block = expr.args[n:(n + 3)]
            if is_aside(block)
                get_aside!(output, moduledata, state, file, block)
            elseif isdocblock(block)
                get_docs!(output, moduledata, state, file, block)
            end
            process!(output, moduledata, state, file, block[1])
        end
        # Since we partition the argument list into overlapping blocks of 4, the
        # last 3 arguments are not passed to `processast`. Do that now if needed.
        for arg in expr.args[max(length(expr.args) - 3, 1):end]
            process!(output, moduledata, state, file, arg)
        end
        # Check for an aside at the end of a file.
        if length(expr.args) >= 2
            block = (expr.args[end-1], expr.args[end], LineNumberNode(0), nothing) # Dummy line node.
            is_aside(block) && get_aside!(output, moduledata, state, file, block)
        end
    end
    output
end
process!(output, moduledata, state, file, other) = output # Skip non-expressions.


"""
Extract the comment block from expressions and capture metadata.
"""
function get_aside!(output, moddata, state, file, block)
    line, comment, _, _ = block

    docs   = findexternal(first(exec(state, comment)))
    source = (linenumber(line), file)
    object = Aside(file, source[1])

    output.rawstrings[object] = docs
    output.metadata[object]   = @compat(Dict(:textsource => source,
                                             :category => :aside))

    output
end

"""
Extract a docstring and associated object(s) as well as metadata.
"""
function get_docs!(output, moduledata, state, file, block)
    aboveline, docstring, underline, expr = block

    expr = unwrap_macrocall(extract_quoted(expr))

    # Escape if we haven't unwrapped a documentatable object!
    (isdocumentable(expr) && !ismacrocall(expr)) || return output

    docs       = findexternal(exec(state, docstring))
    textsource = (linenumber(aboveline), file)
    codesource = (linenumber(underline), file)

    category = getcategory(expr)

    object   = getobject(category, moduledata, state, expr, codesource)
    metadata = @compat(Dict(:textsource => textsource,
                            :codesource => codesource,
                            :category   => category))

    postprocess!(category, metadata, expr)
    store!(output, object, docs, metadata)

    output
end


"""
Add some additional metadata for macros and method definitions.
"""
postprocess!(cat::Symbol, metadata, ex) = postprocess!(Head{cat}(), metadata, ex)

function postprocess!(H"macro", metadata, ex)
    metadata[:signature] = ex.args[1]
    metadata[:code]      = ex
    metadata
end
function postprocess!(H"method", metadata, ex)
    ismethod(ex) && (metadata[:code] = ex)
    metadata
end
postprocess!(::Head, metadata, ex) = metadata # No-op.


"""
Save docstrings and metadata for the objects that have been found.
"""
function store!(output, object, docs, metadata)
    metadata[:category]       = recheck(object, metadata[:category])
    output.rawstrings[object] = docs
    output.metadata[object]   = metadata
end
function store!(output, objects::Set, docs, metadata)
    for object in objects
        store!(output, object, deepcopy(docs), deepcopy(metadata))
    end
end
function store!(output, objectgroups::Tuple, docs, metadata)
    for objects in objectgroups
        store!(output, objects, docs, metadata)
    end
end
