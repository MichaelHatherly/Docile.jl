["Helper functions for docstring filtering and collection."]

"""
Find all objects described by an expression.
"""
getobject(cat::Symbol, moduledata, state, expr, codesource) =
    getobject(Head{cat}(), moduledata, state, expr, codesource)

"""
Find all `Method` objects defined by a given expression.

Used to associate a docstring with one or more methods or inner constructors of
a type.

    " ... "
    f(x, y = 1) = x + y

    type T
        x :: Int
        " ... "
        T(x, y) = new(x + y)
    end

"""
getobject(H"method", moduledata, state, expr, codesource) =
    findmethods(state, expr, codesource)

getobject(H"global, typealias", ::Any, state, expr, ::Any) =
    getvar(state, name(expr))

getobject(H"type, symbol", moduledata, state, expr, ::Any) =
    getfield(moduledata.modname, getvar(state, name(expr)))

"""
Get the `(anonymous function)` object defined by a macro expression.

Used to associate docstrings with macros

    " ... "
    macro mac(args...)

    end

"""
getobject(H"macro", moduledata, state, expr, ::Any) =
    getfield(moduledata.modname, macroname(getvar(state, name(expr))))

"""
Find group of methods that match a provided signature.

Syntax example

    " ... "
    (a, Any, Vararg{Int})

defines a docstring `" ... "` for all `Method` objects of `Function` `a`
that match the signature `(Any, Int...)`.

If `a` is not yet defined at the point where the docstring is placed, then quote
the function name as follows:

    " ... "
    (:a, Any, Vararg{Int})

"""
getobject(H"tuple", ::Any, state, expr, ::Any) = findtuples(state, expr)

"""
Find a set of methods and a set of functions that match the provided vector.

Syntax example

    " ... "
    [a, :b, (d, Any, Int)]

will associate the docstring `" ... "` with the functions `a` and `b` as well as
all methods of function `d` matching the signature `(Any, Int)`.

This syntax is a generalisation of the single symbol syntax

    " ... "
    a

or

    " ... "
    :b

and the method syntax using a tuple

    " ... "
    (d, Any, Int)

"""
getobject(H"vcat, vect", ::Any, state, expr, ::Any) = findvcats(state, expr)


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
is_aside(block) = isline(block[1]) &&
    (is_aside_syntax(block[2]) || is_comment_syntax(block[2]))

is_aside_syntax(ex)   = isvect(ex) && isdocstring(ex.args[1])
is_comment_syntax(ex) = ismacrocall(ex) && ex.args[1] == symbol("@comment")

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
        root    = normpath(root)
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
