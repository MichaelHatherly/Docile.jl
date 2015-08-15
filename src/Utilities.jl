"""
    Utilities
"""
module Utilities

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

end
