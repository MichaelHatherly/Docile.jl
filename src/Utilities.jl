"""
    Utilities

> Common utility methods and macros for the package.

"""
module Utilities

using Base.Meta

export Str, concat!, tryget, @with, evalblock, submodules


typealias Str AbstractString

concat!(xs, x) = push!(xs, x)
concat!(xs, ys :: Vector) = append!(xs, ys)

tryget(mod, field, default) = isdefined(mod, field) ? getfield(mod, field) : default

macro with(var, func)
    n = var.args[1]
    quote
        let t = $n
            $var
            $func
            $n = t
            nothing
        end
    end |> esc
end

"""
    @object(ex)

> Return the object/binding that an expression represents.

"""
macro object(ex)
    if isexpr(ex, :call)
        name = esc(Base.Docs.namify(ex.args[1]))
        if any(x -> isexpr(x, :(::)), ex.args)
            :(methods($(name), $(esc(Base.Docs.signature(ex))))[1])
        else
            :(@which($(esc(ex))))
        end
    elseif Base.Docs.isvar(ex)
        :(Base.Docs.@var($(esc(ex))))
    else
        esc(ex)
    end
end

function evalblock(modname, block)
    result = nothing
    cursor = 1
    while cursor < length(block)
        expr, cursor = parse(block, cursor)
        result = eval(modname, expr)
    end
    result
end

function submodules(mod :: Module, out = Set())
    push!(out, mod)
    for name in names(mod, true)
        if isdefined(mod, name)
            object = getfield(mod, name)
            validmodule(mod, object) && submodules(object, out)
        end
    end
    out
end

validmodule(a :: Module, b :: Module) = b ≠ a && b ≠ Main
validmodule(a, b) = false

end
