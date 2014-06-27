
"""
Allow use of `\$` and `\\` in doc strings to support LaTeX equations.
"""
macro doc_mstr(text)
    text
end

category(ex, file, line) =
    isfunction(ex) ? :function :
    isglobal(ex)   ? :global   :
    ismacro(ex)    ? :macro    :
    ismodule(ex)   ? :module   :
    istype(ex)     ? :type     :
    error("Cannot document code at $(file):$(line)\n$(ex)")

isdoc(ex)      = isexpr(ex, :macrocall) && endswith(string(ex.args[1]), "mstr")
isfunction(ex) = isexpr(ex, [:function, :(=)]) && isexpr(ex.args[1], :call)
isglobal(ex)   = isexpr(ex, [:const, :global, :(=)]) && !isexpr(ex.args[1], :call)
isinclude(ex)  = isexpr(ex, :call) && ex.args[1] == :include
ismacro(ex)    = isexpr(ex, :macro)
ismodule(ex)   = isexpr(ex, :module)
istype(ex)     = isexpr(ex, [:type, :abstract, :typealias])

const CACHE_DIR = joinpath(Pkg.dir("Docile"), "cache")

function makecache(package::String)
    isdir(CACHE_DIR) || (info("Creating Docile cache."); mkdir(CACHE_DIR))
    path = joinpath(CACHE_DIR, package)
    isdir(path) || (info("Creating cache for $(package)."); mkdir(path))
    path
end
