module Docile

# package code goes here
export generate, update, init, remove, patch!

const CACHE_DIR = joinpath(Pkg.dir("Docile"), "cache")

include("parser.jl")
include("interface.jl")

## Patch help system ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# TODO: Avoid this.
function patch!()
    info("Patching Base.Help.init_help()...")

    code = quote
        cache_dir = joinpath(Pkg.dir("Docile"), "cache")
        if isdir(cache_dir)
            for package in readdir(cache_dir)
                fn = joinpath(cache_dir, package, "helpdb.jl")
                contents = open(readall, fn)
                isfile(fn) && append!(helpdb, evalfile(fn))
            end
        end
    end

    eval(Base.Help, quote

             function init_help() # patched
                 global MODULE_DICT, FUNCTION_DICT
                 if FUNCTION_DICT == nothing
                     info("Loading help data...")
                     helpdb = evalfile(helpdb_filename())

                     $code # patch

                     MODULE_DICT = Dict()
                     FUNCTION_DICT = Dict()
                     for (mod,func,desc) in helpdb
                         if !isempty(mod)
                             mfunc = mod * "." * func
                             desc = decor_help_desc(func, mfunc, desc)
                         else
                             mfunc = func
                         end
                         if !haskey(FUNCTION_DICT, mfunc)
                             FUNCTION_DICT[mfunc] = {}
                         end
                         push!(FUNCTION_DICT[mfunc], desc)
                         if !haskey(MODULE_DICT, func)
                             MODULE_DICT[func] = {}
                         end
                         if !in(mod, MODULE_DICT[func])
                             push!(MODULE_DICT[func], mod)
                         end
                     end
                 end
             end

         end)
end

end # module
