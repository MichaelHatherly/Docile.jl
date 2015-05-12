# Main lookup methods.

"""
Find all methods defined by an method definition expression.

    "A docstring for the methods ``f(::Any)`` and ``f(::Any, ::Any)``"
    f(x, y = 1) = x + y

"""
function findmethods(state::State, ex::Expr, codesource)
    source = (adjustline(ex, codesource[1]), symbol(codesource[2]))
    fname  = funcname(state, ex)
    mset   = Set{Method}()
    for m in allmethods(fname)
        samemodule(state.mod, m) || continue
        lineinfo(m) == source && push!(mset, m)
    end
    mset
end

"""
Function expressions have different line numbers depending on whether
they are "full" or "short":

    f(x) = x

    function g(x)
        x
    end

``f`` will have a ``.line`` value pointing to the start of the expression, while
``g``'s ``.line`` value will point at the first line of the function's body.
"""
adjustline(ex::Expr, line) = isexpr(ex, :function) ? line + 1 : line

"""
Line number and file name pair for a method ``m``.
"""
lineinfo(m::Method) = (m.func.code.line, m.func.code.file)

"""
Is the method ``meth`` defined in the module ``mod``?
"""
samemodule(mod, meth) = mod == getfield(meth.func.code, :module)

"""
Find the ``Method`` objects referenced by ``(...)`` docstring syntax.

    "Shared docstring for all 2 argument methods, first argument an ``Int``."
    (foo, Int, Any)

"""
function findtuples(state::State, expr::Expr)
    fname = exec(state, exec(state, expr.args[1])) # Run twice to get rid of `QuoteNode`s.
    types = tup([exec(state, arg) for arg in expr.args[2:end]]...)
    Set{Method}(methods(fname, types))
end

if VERSION < v"0.4-dev+4319"
    tup(args...) = tuple(args...)
else
    tup(args...) = Tuple{args...}
end

"""
Find ``Function`` and ``Method`` objects referenced by ``[...]`` syntax.

    "Shared docstring for differently named functions."
    [foobar, foobar!]

"""
function findvcats(state::State, expr::Expr)
    funcs, methods = Set{Function}(), Set{Method}()
    for arg in expr.args
        if isa(arg, Symbol) || isa(arg, QuoteNode)
            push!(funcs, exec(state, exec(state, arg))) # Run twice to remove `Quotenode`s.
        elseif isexpr(arg, :tuple)
            union!(methods, findtuples(state, arg))
        else
            error("Invalid '[objects...]' syntax.")
        end
    end
    funcs, methods
end

# End lookup methods.


# Sandboxed execution of a subset of possible Julian expressions.

"""
Evaluate the expression ``expr`` within the context provided by ``state``.
"""
exec(state::State, expr::Expr) = exec(Head{expr.head}(), state, expr)

exec(H".", state, expr) = getfield(exec(state, expr.args[1]), expr.args[2].value)

exec(H"::", state, expr) = exec(state, expr.args[end])
exec(H"kw", state, expr) = exec(state, expr.args[1])

exec(H":", state, expr) = colon(map(a -> indexer(state, a), expr.args)...)

exec(H"...", state, expr) = Vararg{exec(state, expr.args[1])}

exec(H"curly", state, expr) = exec(state, expr.args[1]){exec(state, expr.args[2:end])...}
exec(H"call", state, expr)  = exec(state, expr.args[1])(exec(state, expr.args[2:end])...)

exec(H"macrocall", state, expr) =
    exec(state, exec(state, expr.args[1])(exec(state, expr.args[2:end])...))

exec(H"triple_quoted_string", state, expr) =
    exec(state, Expr(:macrocall, symbol("@mstr"), expr.args...))

exec(H"string", state, expr) = string(exec(state, expr.args)...)
exec(H"tuple", state, expr)  = tuple(exec(state, expr.args)...)

exec(H"vcat, vect", state, expr) = vcat(exec(state, expr.args)...)
exec(H"hcat", state, expr)       = hcat(exec(state, expr.args)...)

exec(H"quote", state, expr) = expr.args[1]

exec(H"$", state, expr) = exec(state, expr.args[1])

function exec(H"ref", state, expr)
    object = exec(state, expr.args[1])
    withref(state, object) do
        getindex(object, map(a -> indexer(state, a), expr.args[2:end])...)
    end
end

exec(state::State, args::Vector) = map(a -> exec(state, a), args)

function exec(state::State, q::Symbol)
    for scope in reverse(state.scopes)
        haskey(scope, q) && return scope[q]
    end
    getfield(state.mod, q)
end

exec(::State, q::QuoteNode) = q.value
exec(::State, constant)     = constant

function indexer(state::State, arg)
    if arg == symbol("end")
        endof(state.refs[end])
    elseif arg == :(:)
        1:endof(state.refs[end])
    else
        exec(state, arg)
    end
end

# End `exec` methods.


# Helper methods for lookup methods `findmethods` and friends.

"""
Extract the expressions from a ``{}`` in a function definition.
"""
gettvars(expr::Expr) = isexpr(expr.args[1], :curly) ? expr.args[1].args[2:end] : Any[]

"""
Extract the expressions representing a method definition's arguments.
"""
getargs(expr::Expr) = expr.args[2:end]


"""
Return the ``Function`` object represented by a method definition expression.
"""
funcname(state::State, expr::Expr) = funcname(Head{expr.head}(), state, expr)

funcname(H"=, function, call, curly", state::State, expr::Expr) = funcname(state, expr.args[1])

funcname(H"$", state::State, expr::Expr) = funcname(state, getvar(state, expr.args[1]))
funcname(H".", state::State, expr::Expr) = getfield(exec(state, expr.args[1]), expr.args[2].value)

funcname(state::State, q::QuoteNode) = funcname(state, q.value)
funcname(state::State, q::Symbol)    = exec(state, exec(state, q))

funcname(::State, other) = other


"""
Given an expression representing a ``TypeVar``, create the equivalent object.
"""
typevar(state::State, x::Expr)   = ((q = x.args[1];), TypeVar(q, exec(state, x.args[2])))
typevar(state::State, q::Symbol) = (q, TypeVar(q, Any))

"""
Build a dictionary mapping ``Symbol`` to ``TypeVar``.
"""
typevars(state::State, args) = Dict{Symbol, TypeVar}([typevar(state, a) for a in args])
typevars(::State, ::Symbol)  = Dict{Symbol, TypeVar}()


mostgeneral(T::DataType) = T{[tvar.ub for tvar in T.parameters]...}
mostgeneral(other)       = other


function allmethods(fname)
    out = Set{Method}()
    for m in methods(fname)
        push!(out, m)
    end
    for m in methods(mostgeneral(fname))
        push!(out, m)
    end
    out
end
