
const HOOKS = symbol("#HOOKS#")

export addhook, directives

"""
    addhook(func)

> Register a function to be called on each docstring prior to storing it.

**Usage:**

```julia
using Docile

reverser(str, def) = (reverse(str), def)

addhook(reverser)

addhook() do str, def
    # ...
end
```

**Note:** registered hooks are only applied to docstrings written after the hook is added.
"""
function addhook(hook :: Function, curmod = current_module())
    isdefined(curmod, HOOKS) || eval(curmod, :(const $(HOOKS) = Function[]))
    push!(getfield(curmod, HOOKS), hook)
end

function docm(str, def)
    for hook in tryget(current_module(), HOOKS, Function[])
        str, def = hook(str, def)
        str ≡ nothing && return def
    end
    Base.Docs.docm(str, def)
end
docm(args...) = Base.Docs.docm(args...)

function __init__()
    # Hook into the Julia documentation system.
    Base.DocBootstrap.setexpand!(docm)
end
