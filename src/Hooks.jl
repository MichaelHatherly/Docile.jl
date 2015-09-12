"""
$(moduleheader())

$(exports())
"""
module Hooks

import ..DocTree

using ..Utilities

const HOOKS = S"#Docile.Hooks.HOOKS#"

hooks(m)  = @get m HOOKS Function[]
hooks!(m) = @get m HOOKS eval(m, :(const $HOOKS = Function[]))

export register!
"""
    register!(def)
"""
register!(def :: Function) = push!(hooks!(current_module()), def)

function docm(str, def)
    for f in hooks(current_module())
        exit, str, def = f(str, def)
        exit && return esc(def)
    end
    Base.Docs.docm(str, def)
end
docm(others...) = Base.Docs.docm(others...)

__init__() = Base.DocBootstrap.setexpand!(docm)


# Pre-defined hooks.

export track
"""
    track([t])
"""
track(t = __trace__) = (s, d) -> (push!(t, (current_module(), s, d)); (false, s, d))

const __trace__ = []


const __DOC__ = S"#Docile.Hooks.__doc__#"

export @__doc__
"""
    @__doc__(ex)
"""
macro __doc__(ex) esc(Expr(:block, __DOC__)) end

export __doc__
"""
    __doc__(str, def)
"""
__doc__(str, def) = __doc__!(str, macroexpand(def))

function __doc__!(str, def :: Expr)
    found = false
    if isexpr(def, :block) && length(def.args) == 2 && def.args[1] == __DOC__
        def.head = :macrocall
        def.args = [S"@doc", str, def.args[end]]
        found = true
    else
        for each in def.args
            exit, str, def = __doc__!(str, each)
            found |= exit
        end
    end
    found, str, def
end
__doc__!(str, def) = false, str, def


export directives
"""
    directives(str, def)
"""
directives(str, def) = false, DocTree.exprnode(str), def

end
