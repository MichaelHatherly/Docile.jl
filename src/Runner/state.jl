"""
Hold state for use with `exec` to determine the objects referenced by symbols.
"""
type State
    mod    :: Module
    scopes :: Vector{Dict}
    refs   :: Vector

    State(mod, scopes = Dict[]) = new(mod, scopes, Any[])
end

# Scope manipulations.

pushscope!(state, scope) = push!(state.scopes, scope)
popscope!(state)         = pop!(state.scopes)

# Ref manipulations.

pushref!(state, ref) = push!(state.refs, ref)
popref!(state)       = pop!(state.refs)

"""
Push reference onto `state`, run function block, and pop reference afterwards.
"""
function withref(fn, state, ref)
    pushref!(state, ref)
    result = fn()
    popref!(state)
    result
end

function getvar(state, var)
    for scope in reverse(state.scopes)
        haskey(scope, var) && return scope[var]
    end
    var
end

"""
Add new variable and it's value to topmost scope.
"""
function addtoscope!(state, var, value)
    isempty(state.scopes) && pushscope!(state, Dict())
    setindex!(state.scopes[end], value, var)
end
