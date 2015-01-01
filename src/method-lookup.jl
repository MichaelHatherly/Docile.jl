type State
    mod    :: Module
    scopes :: Vector{Dict}
    refs   :: Vector

    State(mod) = new(mod, Dict[], Any[])
    State(mod, scopes) = new(mod, scopes, Any[])
end

pushscope!(state::State, scope::Dict) = push!(state.scopes, scope)
popscope!(state::State) = pop!(state.scopes)

pushref!(state::State, object) = push!(state.refs, object)
popref!(state::State) = pop!(state.refs)

function addtoscope!(state::State, variable::Symbol, value)
    length(state.scopes) == 0 && push!(state.scopes, Dict())
    push!(state.scopes[end], variable, value)
end

"Search scopes for variable with name ``var``. Returns ``var`` if not found."
function getvar(state::State, variable::Symbol)
    for scope in reverse(state.scopes)
        haskey(scope, variable) && return scope[variable]
    end
    variable
end

"Symbolic dispatch type."
immutable Head{S} end

"Symbolic dispatch on ``head`` field on an expression. Union using comma separated list."
macro H_str(text)
    heads = [Head{symbol(part)} for part in split(text, ", ")]
    Expr(:(::), Expr(:call, :Union, heads...))
end

funccall(ex::Expr)    = funccall(Head{ex.head}(), ex)
funccall(::Head, ex)  = ex.args[1]
funccall(H"call", ex) = ex

gettvars(ex::Expr) = iscurly(ex.args[1]) ? ex.args[1].args[2:end] : Any[]

getargs(ex::Expr) = ex.args[2:end]

funcname(state::State, ex::Expr) = funcname(Head{ex.head}(), state, ex)

funcname(H"=, function, call, curly", state::State, ex::Expr) = funcname(state, ex.args[1])

funcname(H"$", state::State, ex::Expr) = funcname(state, getvar(state, ex.args[1]))
funcname(H".", state::State, ex::Expr) = getfield(sig(state, ex.args[1]), ex.args[2].value)

funcname(state::State, qn::QuoteNode) = funcname(state, qn.value)
funcname(state::State, q::Symbol)     = sig(state, sig(state, q))
funcname(::State, other)              = other

sig(state::State, ex::Expr) = sig(Head{ex.head}(), state, ex)

sig(H".", state, ex) = sig(sig(state, ex.args[1]), ex.args[2], true)

sig(mod::Module, qn::QuoteNode, ::Bool) = getfield(mod, qn.value)
sig(::State, qn::QuoteNode) = qn.value

sig(H"::", state, ex) = sig(state, ex.args[end])
sig(H"kw", state, ex) = sig(state, ex.args[1])

sig(H":", state, ex) = colon(map(a -> indexer(state, a), ex.args)...)

sig(H"...", state, ex) = Vararg{sig(state, ex.args[1])}

sig(H"curly", state, ex) = sig(state, ex.args[1]){msig(state, ex.args[2:end])...}
sig(H"call", state, ex) = sig(state, ex.args[1])(msig(state, ex.args[2:end])...)
sig(H"macrocall", state, ex) = sig(state, sig(state, ex.args[1])(msig(state, ex.args[2:end])...))

sig(H"string", state, ex) = string(msig(state, ex.args)...)
sig(H"tuple", state, ex) = tuple(msig(state, ex.args)...)

sig(H"vcat", state, ex) = vcat(msig(state, ex.args)...)
sig(H"hcat", state, ex) = hcat(msig(state, ex.args)...)

# Refs need access the object being referenced so that they can use "end" and ":" correctly.
function sig(H"ref", state, ex)
    # Find the object being referenced.
    object = sig(state, ex.args[1])

    # Add it as the most recently referenced object.
    pushref!(state, object)

    # Index into the object taking into account "end" and ":" tokens with ``indexer``.
    result = getindex(object, map(a -> indexer(state, a), ex.args[2:end])...)

    # We're now done with indexing into this object so pop it from the stack.
    popref!(state)

    result # Return the actual indexing result from expression ``x``.
end

function indexer(state, arg)
    if arg ≡ :end
        endof(state.refs[end])
    elseif arg ≡ :(:)
        1:endof(state.refs[end])
    else
        sig(state, arg)
    end
end

sig(H"quote", state, ex) = ex.args[1]

sig(H"$", state, ex) = sig(state, ex.args[1])

msig(state, args) = map(a -> sig(state, a), args)

function sig(state::State, q::Symbol)
    for i in length(state.scopes):-1:1
        haskey(state.scopes[i], q) && return state.scopes[i][q]
    end
    getfield(state.mod, q)
end

sig(::State, constant) = constant

## TypeVars

typevar(state, ex::Expr) = ((q = ex.args[1];), TypeVar(q, sig(state, ex.args[2])))
typevar(state, q::Symbol) = (q, TypeVar(q, Any))

typevars(state, args)       = Dict{Symbol, TypeVar}([typevar(state, a) for a in args])
typevars(::State, ::Symbol) = Dict{Symbol, TypeVar}() # No parametric types.

function argtype(state, ex::Expr)
    if ex.head == :(...) && isa(ex.args[1], Symbol)
        Vararg{Any}
    else
        sig(state, ex)
    end
end
argtype(::State, ::Symbol) = Any # Untyped argument.

function argtypes(state, args)
    types, numkws = Any[], 0
    for arg in args
        isexpr(arg, :parameters) && continue # Dispatch not dependant on parameters.
        push!(types, argtype(state, isexpr(arg, :kw) ? (numkws += 1; arg.args[1]) : arg))
    end
    tuple(types...), numkws
end

# Types of the form Foobar{T} appear not to have any associated methods. Replace
# the TypeVars with upperbound "actual" types.
mostgeneral(T::DataType) = T{[tvar.ub for tvar in T.parameters]...}
mostgeneral(other)       = other

function findmethods(state::State, ex::Expr)
    fname, fcall = mostgeneral(funcname(state, ex)), funccall(ex)

    pushscope!(state, typevars(state, gettvars(fcall))) # Add parametric types to scope.

    args, numkws = argtypes(state, getargs(fcall)) # Gather arguments types and count optionals.

    # Find all methods created by the given expression ``ex``.
    mset = Set{Method}()

    for m in methods(fname), n in 0:numkws
        # Try to match each subset of args tuple (left-to-right) with method signatures.
        issigmatch(fname, m, args[1:end - n]) && push!(mset, m)

        # Finish, since we should have found all the methods by now.
        length(mset) > numkws && break
    end

    popscope!(state) # Remove parametric types from scope.

    mset
end

### Handle call overloading differences between versions.
if VERSION > v"0.4-"
    issigmatch(fname::DataType, method, args) = issigmatch(method.sig[2:end], args)
else
    issigmatch(fname::DataType, method, args) = issigmatch(method.sig, args)
end
issigmatch(fname, method, args) = issigmatch(method.sig, args)

issigmatch(sig, args) = issubtype(sig, args) || sig == args
###

## Unravel loops containing ``@eval`` blocks. Quite basic, no conditional or body variables.

function unravel(objects, meta, state, file, ex::Expr)
    unravel(Head{ex.head}(), objects, meta, state, file, ex)
end
unravel(objects, meta, state, file, other) = objects

function unravel(::Head, objects, meta, state, file, ex::Expr)
    for arg in ex.args
        unravel(objects, meta, state, file, arg)
    end
    objects
end
unravel(::Head, objects, meta, state, file, ex) = objects

function unravel(H"for", objects, meta, state, file, ex::Expr)

    # Skip loops with no ``@eval`` inside.
    is_eval_block(ex) || return objects

    # Rewrite "multi" for loops to nested one. Capture outer loop variables.
    ex, vars = expandloop(state, ex)

    # Execute the outer loop.
    for val in sig(state, vars[2])
        pushscope!(state, newscope(vars[1], val))
        unravel(objects, meta, state, file, ex)
        popscope!(state)
    end

    objects
end

function unravel(H"macrocall", objects, meta, state, file, ex::Expr)
    merge!(objects, processast(meta, state, file, ex))
end

expandloop(state, ex::Expr) = expandloop(Head{ex.args[1].head}(), state, ex)

function expandloop(H"block", state, ex)
    vars, body = ex.args
    outer, inner = vars.args[1], Expr(:block, vars.args[2:end]...)
    isempty(inner.args) ? body.args[end] : Expr(:for, inner, body), loopvars(outer.args...)
end
expandloop(H"=", state, ex) = (ex.args[end], loopvars(ex.args[1].args...))

"Build a new scope from loop variables with same shape."
newscope(vars, vals) = newscope!(Dict{Symbol, Any}(), vars, vals)

function newscope!(out::Dict{Symbol, Any}, vars::Vector, vals::Tuple)
    for (var, val) in zip(vars, vals)
        newscope!(out, var, val)
    end
    out
end
newscope!(out::Dict{Symbol, Any}, var::Symbol, val) = push!(out, var, val)

loopvars(H"block", ex::Expr) = [loopvars(arg.args[1], arg.args[2]) for arg in ex.args]
loopvars(H"=",     ex::Expr) = [loopvars(ex.args[1], ex.args[2])]

loopvars(var::Symbol, val) = (var, val)
loopvars(vars::Expr,  val) = (vars.args, val)

"Capture loop variables in scope dicts."
loopvars

function is_eval_block(ex::Expr)
    (ismacrocall(ex) && ex.args[1] ≡ symbol("@eval")) && return true
    for arg in ex.args
        is_eval_block(arg) && return true
    end
    false
end
is_eval_block(ex) = false
