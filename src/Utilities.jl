module Utilities

using Compat, Base.Meta

export Head, @H_str, issymbol, isexpr, parsefile

immutable Head{S} end

macro H_str(text)
    Expr(:(::), Expr(:call, :Union, [Head{symbol(part)} for part in split(text, ", ")]...))
end

issymbol(::Symbol) = true
issymbol(::Any)    = false

function parsefile(file)
    text = readall(file)
    try
        result = parse("begin $(text)\n end")
        isexpr(result, :incomplete) ? parse(text) : result
    catch
        Expr(:block)
    end
end


"""
Print a 'Docile'-formatted message to ``STDOUT``.
"""
message(msg::AbstractString) = print_with_color(:magenta, "Docile: ", msg, "\n")


"""
Is the module where a function/method is defined the same as ``mod``?
"""
samemodule(mod, def::Method)    = getfield(def.func.code, :module) == mod
samemodule(mod, func::Function) = getfield(func.code, :module) == mod
samemodule(mod, other)          = false


"""
Path to Julia's base source code.
"""
const BASE = abspath(joinpath(JULIA_HOME, "..", "share", "julia", "base"))

"""
Convert a path to absolute. Relative paths are guessed to be from Julia ``/base``.
"""
expandpath(path) = normpath(isabspath(path) ? path : joinpath(BASE, path))

end
