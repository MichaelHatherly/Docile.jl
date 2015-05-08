["Helper functions for docstring filtering and collection."]

"""
Find all objects described by an expression.
"""
getobject(cat::Symbol, moduledata, state, expr) =
    getobject(Head{cat}(), moduledata, state, expr)

getobject(H"method", m, s, x)            = findmethods(s, x)
getobject(H"global, typealias", m, s, x) = getvar(s, name(x))
getobject(H"type, symbol", m, s, x)      = getfield(m.modname, getvar(s, name(x)))
getobject(H"macro", m, s, x)             = getfield(m.modname, macroname(getvar(s, name(x))))
getobject(H"tuple", m, s, x)             = findtuples(s, x)
getobject(H"vcat, vect", m, s, x)        = findvcats(s, x)


"Convert category from `:symbol` to either `:module` or `:function`."; :recheck

recheck(::Module,        ::Symbol) = :module
recheck(::Any,        cat::Symbol) = cat
recheck(::Function,   cat::Symbol) = ifelse(cat == :macro, cat, :function)
recheck(::Method,        ::Symbol) = :method


"""
The category of an expression. `:symbol` is resolved at a later stage by `recheck`.
"""
getcategory(x) =
    ismethod(x) ? :method    :
    ismacro(x)  ? :macro     :
    istype(x)   ? :type      :
    isalias(x)  ? :typealias :
    isglobal(x) ? :global    :
    issymbol(x) ? :symbol    :
    istuple(x)  ? :tuple     :
    isvcat(x)   ? :vcat      :
    isvect(x)   ? :vect      :
    error("@doc: cannot document object:\n$(ex)")


"""
Blacklist some expressions so search doesn't decend into them.
"""
skipexpr(x) =
    ismodule(x) ||
    ismacro(x)  ||
    ismethod(x) ||
    isglobal(x) ||
    istuple(x)  ||
    isvcat(x)   ||
    isvect(x)   ||
    isloop(x)


ismethod(x)       = isexpr(x, [:function, :(=)])       &&  isexpr(x.args[1], :call)
isglobal(x)       = isexpr(x, [:global, :const, :(=)]) && !isexpr(x.args[1], :call)
istype(x)         = isexpr(x, [:type, :abstract])
isconcretetype(x) = isexpr(x, :type)
isalias(x)        = isexpr(x, :typealias)
ismacro(x)        = isexpr(x, :macro)
ismacrocall(x)    = isexpr(x, :macrocall)
ismodule(x)       = isexpr(x, :module)
isfor(x)          = isexpr(x, :for)
iscurly(x)        = isexpr(x, :curly)
istuple(x)        = isexpr(x, :tuple)
isvcat(x)         = isexpr(x, :vcat)
isvect(x)         = isexpr(x, :vect)
iswhile(x)        = isexpr(x, :while)
isloop(x)         = isexpr(x, [:for, :while])

"Does the expression represent a docstring?"; :isdocstring

isdocstring(x) = ismacrocall(x) && ismatch(r"(_|_m|m)str", string(x.args[1]))
isdocstring(::AbstractString) = true

isstring(::AbstractString) = true
isstring(::Any)            = false

issymbol(::Symbol) = true
issymbol(::Any)    = false

"""
Does the tuple of expressions represent a valid docstring and associated object?
"""
isdocblock(block) =
    isline(block[1])         &&
    isdocstring(block[2])    &&
    isline(block[3])         &&
    isdocumentable(block[4])

"""
Is the tuple a valid comment block?
"""
is_aside(block) =
    isline(block[1])              &&
    is_aside_syntax(block[2])     &&
    isdocstring(block[2].args[1])

"""
Handle older `@comment` syntax for asides/comments.
"""
is_aside_syntax(ex) =
    isexpr(ex, [:vect, vcat]) ||
    (isexpr(ex, :macrocall) && ex.args[1] == symbol("@comment"))

isline(::LineNumberNode) = true
isline(x::Expr)          = isexpr(x, :line)
isline(::Any)            = false

isquote(::QuoteNode) = true
isquote(::Any)       = false

isdocumentable(ex) =
    ismethod(ex)    ||
    ismacro(ex)     ||
    istype(ex)      ||
    isalias(ex)     ||
    isglobal(ex)    ||
    issymbol(ex)    ||
    isquote(ex)     ||
    ismacrocall(ex) ||
    istuple(ex)     ||
    isvcat(ex)      ||
    isvect(ex)


extract_quoted(qn::QuoteNode) = qn.value
extract_quoted(other)         = other

unwrap_macrocall(expr::Expr) = (ismacrocall(expr) && (expr = expr.args[2]); expr)
unwrap_macrocall(other)      = other

linenumber(x::LineNumberNode) = x.line
linenumber(x::Expr)           = x.args[1]

macroname(ex) = symbol("@$(ex)")


"""
Check whether a docstring is acutally a file path. Read that instead if it is.
"""
findexternal(docs) = (length(docs) < 256 && isfile(docs)) ? readall(docs) : docs


"""
Extract the module expression corresponding to a `Module` object.
"""
function findmodule(expr::Expr, mod::Module)
    result = findmodule(expr, module_name(mod))
    isexpr(result, :missing) ? throw(ErrorException("Missing module.")) : result
end
function findmodule(expr::Expr, mod::Symbol)
    samemodule(expr, mod) && return expr
    for arg in expr.args
        result = findmodule(arg, mod)
        isexpr(result, :module) && return result
    end
    Expr(:missing)
end
findmodule(other, mod) = Expr(:missing)

"""
Return the `PackageData` objects associated with a set of files.
"""
function findpackages(rootfiles::Set{UTF8String})
    packages = Dict{Module, PackageData}()
    parsed   = Dict{UTF8String, Expr}()
    for root in rootfiles
        files   = matching(f -> isfile(f) && endswith(f, ".jl"), dirname(root))
        modules = Set{Module}()
        for file in files
            haskey(parsed, file) || (parsed[file] = parsefile(file))
            definedmodules!(modules, parsed[file])
        end
        for mod in modules
            packages[mod] = PackageData(mod, root, files, parsed)
        end
    end
    packages
end

"""
Return the set of toplevel modules that are defined in an expression.
"""
function definedmodules!(out, expr::Expr)
    if isexpr(expr, :module)
        name = expr.args[2]
        if isdefined(Main, name)
            object = getfield(Main, name)
            isrootmodule(object) && push!(out, object)
        end
    end
    for arg in expr.args
        definedmodules!(out, arg)
    end
    out
end
definedmodules!(out, other) = out

"""
Is the module a toplevel one not including the module `Main`?
"""
isrootmodule(m::Module) = module_parent(m) == Main && m != Main
isrootmodule(other)     = false

"""
Does the expression `expr` represent the module name `mod`?
"""
samemodule(expr, mod) = isexpr(expr, :module) && expr.args[2] == mod


"Extract the symbol identifying an expression."; :name

function name(ex::Expr)
    n = isa(ex.args[1], Bool)    ? ex.args[2] :           # types
        isexpr(ex.args[1], :(.)) ? ex.args[1].args[end] : # qualified names
        ex.args[1]
    name(n)
end
name(q::QuoteNode) = q.value
name(s::Symbol)    = s


"""
Add and remove a type parameter scope for a function block.
"""
function scoped(func::Function, state::State, ex::Expr)
    (t = isconcretetype(ex)) && pushscope!(state, typevars(state, typeparams(ex.args[2])))
    func()
    t && popscope!(state)
end


"Extract the type parameters from an expression."; :typeparams

typeparams(s::Symbol)   = Any[]
typeparams(ex::Expr)    = isexpr(ex, :(<:)) ?
    typeparams(ex.args[1]) : ex.args[2:end]

"""
Check for a `.docile` configuration file in the directory `dir`.

Load the file if it is found. The file should end with a `Dict{Symbol, Any}`
and can contain any additional Julia code such as method extensions for
the `metamacro` function and custom docstring formatters.

    import Docile: Formats

    immutable MyCustomFormatter <: Formats.AbstractFormatter end

    Formats.parsedocs(::Formats.Format, raw, mod, obj) = # ...

    function Formats.metamacro(::Formats.MetaMacro{:custom}, body, mod, obj)
        # ...
    end

    # Provide additional metadata to package and its modules. Must be last in file.
    Dict(
        :format => MyCustomFormatter,
        # ...
    )
"""
function getdotfile(dir::AbstractString)
    file = joinpath(dir, ".docile")
    isfile(file) ?
        convert(Dict{Symbol, Any}, evalfile(file)) :
        Dict{Symbol, Any}()
end
