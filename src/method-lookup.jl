# Symbolic dispatch type.
immutable Head{S} end

# Dispatch on `head` field of expression. Union using comma separated list.
macro H_str(text)
    heads = [Head{symbol(part)} for part in split(text, ", ")]
    Expr(:(::), Expr(:call, :Union, heads...))
end

"""
The `State` type holds the data for evaluating expressions using `exec`.

**Fields:**

* `mod`: The module object where expressions will be evaluated.
* `scopes`: Stack of local variables defined by for-loops and type parameters.
* `refs`: Stack of objects being indexed into to handle `end` and `:` uses.

**Example:**

```julia
state = Docile.State(Main)
```
"""
type State
    mod    :: Module
    scopes :: Vector{Dict}
    refs   :: Vector

    State(mod) = new(mod, Dict[], Any[])
    State(mod, scopes) = new(mod, scopes, Any[])
end

"Add a new scope to top of `state`'s stack of scopes."
pushscope!(state::State, scope::Dict) = push!(state.scopes, scope)

"Remove the scope from the top of `state`'s scopes stack."
popscope!(state::State) = pop!(state.scopes)

"Push an object onto the top of a `state`'s index references stack."
pushref!(state::State, object) = push!(state.refs, object)

"Remove the object from the top of `state`'s index references stack."
popref!(state::State) = pop!(state.refs)

function getvar(state::State, var::Symbol)
    for scope in reverse(state.scopes)
        haskey(scope, var) && return scope[var]
    end
    var
end

function addtoscope!(state::State, var::Symbol, value)
    length(state.scopes) == 0 && push!(state.scopes, Dict())
    setindex!(state.scopes[end], value, var)
end

"Extract the `Expr(:call, ...)` from the given `ex`."
funccall(ex::Expr)    = funccall(Head{ex.head}(), ex)

funccall(::Head, ex)  = ex.args[1]
funccall(H"call", ex) = ex

"Extract quoted type parameters from an expression."
gettvars(ex::Expr) = iscurly(ex.args[1]) ? ex.args[1].args[2:end] : Any[]

"Extract quoted argument expressions from a method call expression."
getargs(ex::Expr) = ex.args[2:end]

"""
Return the `Function` object contained in expression `ex`.

This method can handle single line function expressions, standard
`function ... end` expressions, ones containing type parameters, and will
also extract the `Function` object from method calls.

`\$` interpolated expressions are also handled for cases where the expression is
evaluated in a for-loop containing `@eval`.

**Example:**

```julia
f(x) = 2x

state = Docile.State(current_module())

Docile.funcname(state, :(f(x) = 2x))
Docile.funcname(state, :(f(x)))
```
"""
funcname(state::State, ex::Expr) = funcname(Head{ex.head}(), state, ex)

funcname(H"=, function, call, curly", state::State, ex::Expr) = funcname(state, ex.args[1])

funcname(H"$", state::State, ex::Expr) = funcname(state, getvar(state, ex.args[1]))
funcname(H".", state::State, ex::Expr) = getfield(exec(state, ex.args[1]), ex.args[2].value)

funcname(state::State, qn::QuoteNode) = funcname(state, qn.value)
funcname(state::State, q::Symbol)     = exec(state, exec(state, q))
funcname(::State, other)              = other

"""
Execute expression `ex` in the context provided by `state`.

Given an `Expr` and an a `State` object we walk the expression tree replacing
symbols with their actual values as determined by the provided `state` variable.

This method's main purpose is to evaluate method signatures and is *not*
designed to act as a replacement for `eval` in any way.

Some expression classes that `exec` should be able to interpret are:

* Symbols defined in a module or scope provided by the `state` object.
* Qualified names, ie. `MyModule.foo`.
* Method and macro calls.
* Type parameters.
* Vararg syntax.
* Tuples and vectors (both `hcat` and `vcat`).
* Basic indexing syntax with unnested `end` and `:`.
* String interpolation.
* `:` range syntax (both `a:b` and `a:b:c`).
* `\$` interpolation for simple `@eval`-style code generation in for-loops.
* Constants.

**Example:**

```julia
vec = [1, 2, 3]

state = Docile.State(current_module())

Docile.exec(state, :(vec[1:2]))
Docile.exec(state, :(1 + 2 + 3))
Docile.exec(state, :("This is a vector: \$(vec)"))
Docile.exec(state, :(Union(Vector{Int}, Array{Float64, 3})))
```
"""
exec(state::State, ex::Expr) = exec(Head{ex.head}(), state, ex)

## Start exec methods. ------------------------------------------------------------------

exec(H".", state, ex) = getfield(exec(state, ex.args[1]), ex.args[2].value)

exec(H"::", state, ex) = exec(state, ex.args[end])
exec(H"kw", state, ex) = exec(state, ex.args[1])

exec(H":", state, ex) = colon(map(a -> indexer(state, a), ex.args)...)

exec(H"...", state, ex) = Vararg{exec(state, ex.args[1])}

exec(H"curly", state, ex) = exec(state, ex.args[1]){exec(state, ex.args[2:end])...}
exec(H"call", state, ex) = exec(state, ex.args[1])(exec(state, ex.args[2:end])...)

function exec(H"macrocall", state, ex)
    exec(state, exec(state, ex.args[1])(exec(state, ex.args[2:end])...))
end

function exec(H"triple_quoted_string", state, ex)
    exec(state, Expr(:macrocall, symbol("@mstr"), ex.args...))
end

exec(H"string", state, ex) = string(exec(state, ex.args)...)
exec(H"tuple", state, ex) = tuple(exec(state, ex.args)...)

exec(H"vcat, vect", state, ex) = vcat(exec(state, ex.args)...)
exec(H"hcat", state, ex) = hcat(exec(state, ex.args)...)

# Refs need access to object being referenced so they can use "end" and ":" correctly.
function exec(H"ref", state, ex)
    # Find the object being referenced.
    object = exec(state, ex.args[1])

    # Add it as the most recently referenced object.
    pushref!(state, object)

    # Index into object taking into account "end" and ":" tokens with ``indexer``.
    result = getindex(object, map(a -> indexer(state, a), ex.args[2:end])...)

    # We're now done with indexing into this object so pop it from the stack.
    popref!(state)

    result # Return the actual indexing result from expression ``ex``.
end

function indexer(state, arg)
    if arg ≡ symbol("end")
        endof(state.refs[end])
    elseif arg ≡ :(:)
        1:endof(state.refs[end])
    else
        exec(state, arg)
    end
end

exec(H"quote", state, ex) = ex.args[1]

exec(H"$", state, ex) = exec(state, ex.args[1])

exec(state::State, args::Vector) = map(a -> exec(state, a), args)

function exec(state::State, q::Symbol)
    for scope in reverse(state.scopes)
        haskey(scope, q) && return scope[q]
    end
    getfield(state.mod, q)
end

exec(::State, qn::QuoteNode) = qn.value

exec(::State, constant) = constant

## End exec methods. --------------------------------------------------------------------

# Create a `TypeVar` from and expression and current `state`.
typevar(state, ex::Expr) = ((q = ex.args[1];), TypeVar(q, exec(state, ex.args[2])))
typevar(state, q::Symbol) = (q, TypeVar(q, Any))

# Create a dictionary of type parameters.
typevars(state, args)       = Dict{Symbol, TypeVar}([typevar(state, a) for a in args])
typevars(::State, ::Symbol) = Dict{Symbol, TypeVar}() # No parametric types.

# Extract the argument's type.
function argtype(state, ex::Expr)
    if ex.head == :(...) && isa(ex.args[1], Symbol)
        Vararg{Any}
    else
        exec(state, ex)
    end
end
argtype(::State, ::Symbol) = Any # Untyped argument.

# For a list of expressions return a tuple of the corresponding types.
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

"""
Return set of methods defined by an expression `ex` as if it had been evaluated.

For methods with `n` optional arguments the method returns all those `n` methods
defined by the expression `ex`. `findmethods` handles type parameters in inner
constructors correctly if they have already been pushed into the `state`'s scope
stack.

When no methods are found to match an expression then an error is raised.

**Example:**

```julia
foobar(x, y = 1) = x + y
state = Docile.State(current_module())
Docile.findmethods(state, :(foobar(x, y = 1) = x + y))
```
"""
function findmethods(state::State, ex::Expr)
    fname, fcall = funcname(state, ex), funccall(ex)

    pushscope!(state, typevars(state, gettvars(fcall))) # Add parametric types to scope.

    args, numkws = argtypes(state, getargs(fcall)) # Gather arguments types and count optionals.

    # Find all methods created by the given expression ``ex``.
    mset = Set{Method}()

    for m in allmethods(fname), n in 0:numkws
        # Try to match each subset of args tuple (left-to-right) with method signatures.
        issigmatch(fname, m, args[1:end - n]) && push!(mset, m)

        # Finish, since we should have found all the methods by now.
        length(mset) > numkws && break
    end

    # When a different number of methods are found then we've probably hit a bug.
    if length(mset) != (numkws + 1)
        detailed_error(fname, numkws, args, mset)
    end

    popscope!(state) # Remove parametric types from scope.

    mset
end

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

### Handle differences between versions.

# TODO: remove once Compat.jl has something to cover this change.
if VERSION ≥ v"0.4-4319"
    tup(args...) = Tuple{args...}
else
    tup(args...) = tuple(args...)
end

# Tuple overhaul.
if VERSION ≥ v"0.4-4319"
    tuple_collect(sig) = collect(sig.parameters)
else
    tuple_collect(sig) = collect(sig)
end

# Call overloading differences.
if VERSION > v"0.4-"
    issigmatch(fname::DataType, method, args) = issigmatch(tuple_collect(method.sig)[2:end], args)
else
    issigmatch(fname::DataType, method, args) = issigmatch(tuple_collect(method.sig), args)
end
issigmatch(fname, method, args) = issigmatch(tuple_collect(method.sig), args)

issigmatch(sig, args) = sig == collect(args)

###

## Tuple lookup. ------------------------------------------------------------------------

"Get all methods from a quoted tuple of the form `(function, T1, T2, ...)`."
function findtuples(state::State, ex::Expr)
    fname = exec(state, exec(state, ex.args[1])) # Run twice to get rid of QuoteNodes.
    types = tup(map(arg -> exec(state, arg), ex.args[2:end])...)
    Set{Method}(methods(fname, types))
end

## [] lookup. ---------------------------------------------------------------------------

function findvcats(state::State, ex::Expr)
    if all(arg -> isa(arg, Symbol) || isa(arg, QuoteNode), ex.args)
        out = Set{Function}()
        for arg in ex.args
            push!(out, exec(state, exec(state, arg)))
        end
        out
    elseif all(arg -> istuple(arg), ex.args)
        out = Set{Method}()
        for arg in ex.args
            union!(out, findtuples(state, arg))
        end
        out
    else
        error("Invalid [objects...] syntax. Either all functions or all method tuples.")
    end
end

## Unravel Loops. -----------------------------------------------------------------------

"""
Execute for-loops containing `@eval` blocks and retrieve documented objects.

When an `Expr(:for, ...)` is encountered do the following:

* Walk inner expressions to find `@eval` blocks. Return if none found.
* For each multi argument loop expand it into nested loops.
* Execute the outer most loop's variable and loop over the value returned.
* For each loop iteration push new scope onto `state` containing value of loop variable.
* Recursively expand the inner loop expressions with this new scope and execute it.
* Pop the current loop iteration's scope after loop has been completed.
"""
function unravel(entries, meta, state, file, ex::Expr)
    unravel(Head{ex.head}(), entries, meta, state, file, ex)
end
unravel(entries, meta, state, file, other) = entries

function unravel(::Head, entries, meta, state, file, ex::Expr)
    for arg in ex.args
        unravel(entries, meta, state, file, arg)
    end
    entries
end
unravel(::Head, entries, meta, state, file, ex) = entries

function unravel(H"for", entries, meta, state, file, ex::Expr)

    # Skip loops with no ``@eval`` inside.
    is_eval_block(ex) || return entries

    # Rewrite "multi" for loops to nested one. Capture outer loop variables.
    ex, vars = expandloop(state, ex)

    # Execute the outer loop.
    for val in exec(state, vars[2])
        pushscope!(state, newscope(vars[1], val))
        unravel(entries, meta, state, file, ex)
        popscope!(state)
    end

    entries
end

function unravel(H"macrocall", entries, meta, state, file, ex::Expr)
    merge!(entries, processast(meta, state, file, ex))
end

expandloop(state, ex::Expr) = expandloop(Head{ex.args[1].head}(), state, ex)

function expandloop(H"block", state, ex)
    vars, body = ex.args
    outer, inner = vars.args[1], Expr(:block, vars.args[2:end]...)
    isempty(inner.args) ? body.args[end] : Expr(:for, inner, body), loopvars(outer.args...)
end
expandloop(H"=", state, ex) = (ex.args[end], loopvars(ex.args[1].args...))

# Build a new scope from loop variables with the same shape.
newscope(vars, vals) = newscope!(Dict{Symbol, Any}(), vars, vals)

function newscope!(out::Dict{Symbol, Any}, vars::Vector, vals::Tuple)
    for (var, val) in zip(vars, vals)
        newscope!(out, var, val)
    end
    out
end
newscope!(out::Dict{Symbol, Any}, var::Symbol, val) = setindex!(out, val, var)

loopvars(H"block", ex::Expr) = [loopvars(arg.args[1], arg.args[2]) for arg in ex.args]
loopvars(H"=",     ex::Expr) = [loopvars(ex.args[1], ex.args[2])]

loopvars(var::Symbol, val) = (var, val)
loopvars(vars::Expr,  val) = (vars.args, val)

function is_eval_block(ex::Expr)
    (ismacrocall(ex) && ex.args[1] ≡ symbol("@eval")) && return true
    for arg in ex.args
        is_eval_block(arg) && return true
    end
    false
end
is_eval_block(ex) = false

## Error reporting.

function detailed_error(fname, numkws, args, mset)
    println("""
    Failed to find the correct method signatures. Stopping.

    **Details:**

    * `fname`:  `$(fname)`
    * `numkws`: `$(numkws)`
    * `args`:   `$(args)`

    * `mset`:
    ```
    $(join([string(m) for m in mset], "\n"))
    ```

    * `allmethods`:
    ```
    $(join([string(m) for m in allmethods(fname)], "\n"))
    ```

    **Version Info:**
    ```""")
    versioninfo()
    println("```")

    error("""
    Please file a bug report including the above information at
    https://github.com/MichaelHatherly/Docile.jl/issues.
    """)
end
