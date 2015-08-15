"""
    Docs
"""
module Docs

using ..Utilities
using ..Directives

const HOOKS = symbol("#HOOKS#")

export addhook, directives

"""
    addhook(func)

> Register a function to be called on each docstring prior to storing it.

**Usage:**

```julia
using Docile.Docs

reverser(str, def) = (reverse(str), def)

addhook(custom)

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
    end
    Base.Docs.docm(str, def)
end
docm(args...) = Base.Docs.docm(args...)

function __init__()
    # Hook into the Julia documentation system.
    Base.DocBootstrap.setexpand!(docm)
end

# Pre-made hooks.

"""
    directives(str, def)

> Docsystem hook for executing ``{{...}}`` directives embedded in docstrings.

**Usage:**

```julia
module MyModule

using Docile.Docs

addhook(directives)

"{{...}}"
f(x) = ...

end
```
"""
directives(str, def) = (build(:string, str), def)

end
