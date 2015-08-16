"""
    Docs
"""
module Docs

using ..Utilities
using ..Directives
using Base.Meta

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
        str ≡ nothing && return def
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

"""
    typefielddocs(str, def)

Capture ``doc""``-style docstrings for type fields. Currently the base docsystem doesn't
detect them correctly.
"""
function typefielddocs(str, def)
    if isexpr(def, :type)
        for x in def.args[end].args
            if isexpr(x, :macrocall) && x.args[1] == symbol("@doc_str")
                x.head = :string
                shift!(x.args)
            end
        end
    end
    str, def
end

"""
    vecdoc(str, def)

A proof-of-concept "short-circuiting" docstring hook. ``nothing`` signals ``docm`` to
return ``def`` instead of passing the results onto the next hook or ``Base.Docs.docm``.
"""
function vecdoc(str, def)
    isexpr(def, :vect) || return str, def
    nothing, Expr(:block, [:(@doc($(esc(str)), $(esc(x)))) for x in def.args]...)
end

end
