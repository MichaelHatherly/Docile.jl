# Parse all included files and create documentation from available docstrings.

"Read contents of ``file`` and parse into an expression."
parsefile(file) = parse("begin $(readall(file)) end")

"Parse ``root`` and ``files``, adding available docstrings to ``objects``."
builddocs!(meta) = (merge!(meta.entries, rootast(meta), includedast(meta)); nothing)

"Extract docstrings from the AST found in the root file of a module."
function rootast(meta)
    # The target module might not be the only toplevel thing in a root file. Only traverse it.
    module_expr = findmodule(parsefile(meta.root), meta.modname).args[end]
    processast(meta, State(meta.modname), meta.root, module_expr)
end

"Extract docstrings from the AST of included files."
function includedast(meta)
    entries = ObjectIdDict()
    for file in meta.files
        merge!(entries, processast(meta, State(meta.modname), file, parsefile(file)))
    end
    entries
end

"Gather valid documentation from a given expression ``ast``."
function processast(meta, state, file, ast::Expr)
    entries = ObjectIdDict()

    should_skip_expr(ast) && return entries # Don't traverse non-toplevel expressions.

    isloop(ast) && return unravel(entries, meta, state, file, ast)

    # Add type parameters to the scope for inner constructor usage.
    isconcretetype(ast) && push_type_scope!(state, ast)

    # For each overlapping 3 arguments in an expression check whether it is a
    # valid documentation block and generate documentation if it is.
    for n = 1:(length(ast.args) - 2)
        block = tuple(ast.args[n:n + 2]...)

        isdocblock(block) && addentry!(entries, processblock(meta, state, file, block)...)
        merge!(entries, processast(meta, state, file, block[1]))
    end

    # Since we partition the argument list into overlapping blocks of 3, the
    # last 2 arguments are not passed to ``processast``. Do that now if needed.
    for arg in ast.args[max(length(ast.args) - 2, 1):end]
        merge!(entries, processast(meta, state, file, arg))
    end

    # Remove the type parameter scope.
    isconcretetype(ast) && popscope!(state)

    entries
end
processast(meta, state, file, other) = ObjectIdDict() # Only traverse expressions.

typeparams(ex::Expr) = _typeparams(ex.args[2])

_typeparams(s::Symbol) = Any[]
_typeparams(ex::Expr)   = isexpr(ex, :(<:))  ? _typeparams(ex.args[1]) : ex.args[2:end]

### Differences in type parameters between versions.
if VERSION > v"0.4-"
    upperbounds(tvars) = tvars
else
    upperbounds(tvars) = Dict{Symbol, Any}([k => v.ub for (k, v) in tvars])
end
###

function push_type_scope!(state::State, ex::Expr)
    pushscope!(state, upperbounds(typevars(state, typeparams(ex))))
end

function addentry!(dict, objects::Set, entry)
    for object in objects
        addentry!(dict, object, entry)
    end
end
addentry!(dict, object, entry) = push!(dict, object, entry)

"Collect object and docstring Entry object from a valid documentation block."
function processblock(meta, state, file, block)
    # Split valid block into docstring, intermediate line, and documentable expression.
    docstring, line, expr = block

    # When encountering a quoted object extract it's value first.
    expr = extract_quoted(expr)

    # Where is the expression located and what category does it belong to?
    source   = (linenumber(line), file)
    category = object_category(expr)

    # Build the docstring object for the given raw ``docstring``.
    docs = Docs{meta.data[:format]}(sig(state, docstring))

    # Get the actual object being documented according to the current module.
    object = object_ref(Head{category}(), meta, state, expr)

    # :symbol category is resolved now into either :function or :module.
    category = recheck_category(object, category)

    entry = Entry{category}(meta.modname, source, docs)

    postprocess_entry!(Head{category}(), meta, entry, expr)

    object, entry
end

recheck_category(::Module, ::Symbol) = :module
recheck_category(::Any, cat::Symbol) = cat
recheck_category(::Function, cat::Symbol) = cat ≡ :symbol ? :function : cat

object_ref(H"method", m, state, ex) = findmethods(state, ex)
object_ref(H"global", m, state, ex) = getvar(state, name(ex))
object_ref(H"type, symbol", m, state, ex) = getfield(m.modname, getvar(state, name(ex)))
object_ref(H"macro", m, state, ex) = getfield(m.modname, macroname(getvar(state, name(ex))))

extract_quoted(qn::QuoteNode) = qn.value
extract_quoted(other) = other

"Get the object/objects created by an expression in the given module."
object_ref

postprocess_entry!(H"macro", meta, entry, expr) = (entry.data[:signature] = expr.args[1];)
postprocess_entry!(::Any, meta, entry, expr) = nothing # Currently a no-op.

"Add additional metadata to an entry based on the category of the entry."
postprocess_entry!

"Symbol representing a macro call to the specified macro ``ex``."
macroname(ex) = symbol("@$(ex)")

"Is the given triplet ``block`` a valid documentation block."
isdocblock(block) = isdocstring(block[1]) && isline(block[2]) && isdocumentable(block[3])

isdocstring(x) = isstring(x) || (ismacrocall(x) && ismatch(r"(_|_m|m)str", string(x.args[1])))
isdocstring(s::AbstractString) = true

"Is the expression ``ex`` a docstring."
isdocstring

ismacrocall(ex) = isexpr(ex, :macrocall)
isstring(ex) = isexpr(ex, :string)

isline(other) = false
isline(lnn::LineNumberNode) = true

"Is this a line?"
isline

linenumber(lnn::LineNumberNode) = lnn.line

"Is the expression ``x`` able to be documented."
isdocumentable(x) = ismethod(x) | ismacro(x) | istype(x) | isglobal(x) | issymbol(x) | isquote(x)

isquote(x::QuoteNode) = true
isquote(other) = false

"Recursively walk an expression searching for a module with the correct name."
function findmodule(ast, modname)
    result = _findmodule(ast, module_name(modname))
    isexpr(result, :missing) ? error("Missing module.") : result
end
function _findmodule(ast::Expr, modname::Symbol)
    samemodule(ast, modname) && return ast
    for arg in ast.args
        res = _findmodule(arg, modname)
        ismodule(res) && return res
    end
    Expr(:missing)
end
_findmodule(other, modname) = Expr(:missing)

"Does the given expression ``ex`` represent a module definition?"
ismodule(ex) = isexpr(ex, :module)

should_skip_expr(ex) = ismodule(ex) || ismacro(ex) || ismethod(ex) || isglobal(ex)

samemodule(ex, s::Symbol) = ismodule(ex) && ex.args[2] == s
samemodule(ex, m::Module) = samemodule(ex, module_name(m))

"Is the given expression ``ex`` the definition of the module ``modname``?"
samemodule
