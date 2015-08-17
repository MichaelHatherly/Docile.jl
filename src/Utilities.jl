"""
    Utilities
"""
module Utilities

using Base.Meta

export Str, concat!, tryget, @with


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

end
