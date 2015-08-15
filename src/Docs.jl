"""
    Docs
"""
module Docs

using ..Utilities

const HOOKS = symbol("#HOOKS#")

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

end
