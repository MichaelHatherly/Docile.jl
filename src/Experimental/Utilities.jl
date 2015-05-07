module Utilities

using Compat, Base.Meta

export Head, @H_str, issymbol, isexpr, parsefile

immutable Head{S} end

abstract AbstractConfig

immutable EmptyConfig <: AbstractConfig end

macro H_str(text)
    Expr(:(::), Expr(:call, :Union, [Head{symbol(part)} for part in split(text, ", ")]...))
end

issymbol(::Symbol) = true
issymbol(::Any)    = false

function parsefile(file)
    text   = readall(file)
    result = parse("begin $(text) end")
    isexpr(result, :incomplete) ? parse(text) : result
end

end
