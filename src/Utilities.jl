module Utilities

using Compat, Base.Meta

export Head, @H_str, issymbol, isexpr, parsefile

# Symbolic dispatch. #

immutable Head{S} end

if VERSION < v"0.4.0-dev"
    macro H_str(text)
        Expr(:(::), Expr(:call, :Union, [Head{symbol(part)} for part in split(text, ", ")]...))
    end
else
    macro H_str(text)
        Expr(:(::), Expr(:curly, :Union, [Head{symbol(part)} for part in split(text, ", ")]...))
    end
end

# File parsing and caching. #

"Internal version of the cache structure."
const CACHE_VER = v"0.0.3"

"Path to Docile's main cache folder."
const CACHE_DIR = normpath(joinpath(dirname(@__FILE__), "..", "cache"))

"The current versioned cache subdirectory set by ``CACHE_VER``"
const CACHE_CUR = joinpath(CACHE_DIR, string(CACHE_VER))

"""
Check cache directory for up to date version directory. Remove older version
directories if any are found. Should be called on module initialisation.
"""
function __init_cache__(cache = CACHE_DIR, current = CACHE_CUR)
    if !isdir(current)
        message("upgrading cache to $(CACHE_VER).")
        mkdir(current)
    end
    for each in readdir(cache)
        handle = joinpath(cache, each)
        if isdir(handle) && handle ≠ current
            rm(handle; recursive = true)
        end
    end
end

"""
Returns the cache path for a given file ``file``.
"""
path_id(file::AbstractString) = joinpath(
    CACHE_CUR,
    string(hash(file)),
    string(hash(mtime(file), hash(VERSION)))
    )

"""
Retrieve the ``Expr`` object from a Julia source file ``file``.

Caches the expression based on it's file name and ``mtime`` value.
"""
function parsefile(file::AbstractString)
    __init_cache__()
    cached = path_id(file)
    if isfile(cached)
        open(deserialize, cached)
    else
        # Read and parse ``file``.
        expr = try
            text = readall(file)
            out  = parse("begin $(text)\n end")
            isexpr(out, :incomplete) ? parse(text) : out
        catch
            warn("could not parse file: '$(file)'.")
            Expr(:block)
        end
        # Remove older versions and cache current ``expr``.
        dir = dirname(cached)
        isdir(dir) && rm(dir; recursive = true)
        mkdir(dir)
        open(cached, "w") do f
            serialize(f, expr)
        end
        expr
    end
end

# Misc. #

"""
Print a 'Docile'-formatted message to ``STDOUT``.
"""
message(msg::AbstractString) = print_with_color(:magenta, "Docile: ", msg, "\n")

"""
Is the module where a function/method is defined the same as ``mod``?
"""
samemodule(mod, def::Method)    = lsdfield(def, :module) == mod
samemodule(mod, func::Function) = lsdfield(func, :module) == mod
samemodule(mod, other)          = false

issymbol(::Symbol) = true
issymbol(::Any)    = false

"""
Path to Julia's base source code.
"""
basepath() = abspath(joinpath(JULIA_HOME, "..", "share", "julia", "base"))

"""
Convert a path to absolute. Relative paths are guessed to be from Julia ``/base``.
"""
expandpath(path) = normpath(isabspath(path) ? path : joinpath(basepath(), path))

# Compat.

lsdfield(x :: Function, f)    = isgeneric(x) ? lsdfield(methods(x), f) : lsdfield(x.code, f)
lsdfield(x :: Method, f)      = lsdfield(x.func, f)
lsdfield(x :: MethodTable, f) = lsdfield(x.defs, f)

lsdfield(x :: LambdaStaticData, f) = getfield(x, f)

end
