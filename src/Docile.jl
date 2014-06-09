module Docile

# package code goes here
export generate, update, init, remove

const CACHE_DIR = joinpath(Pkg.dir("Docile"), "cache")

include("parser.jl")
include("interface.jl")

## Patch help system ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

import TextWrap

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

             function help(io::IO, fname::String, obj=0)
                 init_help()
                 found = false
                 if haskey(FUNCTION_DICT, fname)
                     print_help_entries(io, FUNCTION_DICT[fname])
                     found = true
                 elseif haskey(MODULE_DICT, fname)
                     allmods = MODULE_DICT[fname]
                     alldesc = {}
                     for mod in allmods
                         mfname = isempty(mod) ? fname : mod * "." * fname
                         if isgeneric(obj)
                             #### patched with Main
                             mf = eval(Main, func_expr_from_symbols(map(symbol, split(mfname, "."))))
                             if mf === obj
                                 append!(alldesc, FUNCTION_DICT[mfname])
                                 found = true
                             end
                         else
                             append!(alldesc, FUNCTION_DICT[mfname])
                             found = true
                         end
                     end
                     found && print_help_entries(io, alldesc)
                 elseif haskey(FUNCTION_DICT, "Base." * fname)
                     print_help_entries(io, FUNCTION_DICT["Base." * fname])
                     found = true
                 end
                 if !found
                     if isa(obj, DataType)
                         print(io, "DataType : ")
                         writemime(io, "text/plain", obj)
                         println(io)
                         println(io, " supertype: ", super(obj))
                         if obj.abstract
                             st = subtypes(obj)
                             if length(st) > 0
                                 print(io, " subtypes : ")
                                 showcompact(io, st)
                                 println(io)
                             end
                         end
                         if length(obj.names) > 0
                             println(io, " fields : ", obj.names)
                         end
                     elseif isgeneric(obj)
                         writemime(io, "text/plain", obj); println()
                     else
                         println(io, "No help information found.")
                     end
                 end
             end

         end)
end



end # module
