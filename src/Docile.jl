module Docile

# package code goes here
export generate, update, init, remove, patch!

const CACHE_DIR = joinpath(Pkg.dir("Docile"), "cache")

## Parse documentation files ––––––––––––––––––––––––––––––––––––––––––––––––––

generate(package::String) = cachedocs(package, getdocs(package))

update() = update(readdir(CACHE_DIR)...)
function update(packages::String...)
    for package in packages
        generate(package)
    end
    Base.Help.clear_cache()
end

# TODO: Too fragile.
function parsefile(filename::String)
    text = open(readall, filename)
    beginswith(text, "# ") || error("Format error.")
    parts = split(text, "\n## ")

    helpdb = {}
    modulename = strip(parts[1][3:end])

    for part in parts[2:end]
        name = split(part, r"(\(|{)", 2)[1] # split on { or (
        part = replace(part, "\n", "\n   ") # 3 space indent
        push!(helpdb, (modulename, name, part))
    end

    helpdb
end

function getdocs(package::String)
    helpdb = {}
    path = joinpath(Pkg.dir(package), "doc", "help")
    isdir(path) || error("$(package) is not setup for Docile.")
    for filename in readdir(path)
        fn = joinpath(path, filename)
        endswith(fn, ".md") && append!(helpdb, parsefile(fn))
    end
    helpdb
end

function cachedocs(package::String, helpdb::Vector)
    if !isdir(CACHE_DIR)
        info("Creating Docile/cache.")
        mkdir(CACHE_DIR)
    end

    package_cache = joinpath(CACHE_DIR, package)
    if !isdir(package_cache)
        info("Initializing cache for $(package).")
        mkdir(package_cache)
    end

    open(joinpath(package_cache, "helpdb.jl"), "w") do f
        info("Writing helpdb.jl for $(package).")
        print(f, helpdb)
    end
end

## Add and remove per-package doc directory –––––––––––––––––––––––––––––––––––

function remove(package::String)
    path = joinpath(Pkg.dir(package), "doc")
    config = joinpath(path, "docile.jl")
    isfile(config) || error("$(package) is not setup for Docile.")

    # remove doc/help, doc/docile.jl, and doc (if empty)
    warn("Removing Docile from $(package).")

    rm(config)

    helppath = joinpath(path, "help")
    isdir(helppath) && _recursive_rm(helppath)

    isempty(readdir(path)) && rmdir(path) # only remove doc/ if empty.

    # remove cached helpdb.jl for package.
    dbpath = joinpath(CACHE_DIR, package)
    if isdir(dbpath)
        warn("Removing cache for $(package).")
        _recursive_rm(dbpath)
    else
        info("No cache found for $(package).")
    end
end

function _recursive_rm(dir::String)
    for f in readdir(dir)
        f = joinpath(dir, f)
        if isfile(f)
            rm(f)
        elseif isdir(f)
            _recursive_rm(f) # subdirs
        end
    end
    rmdir(dir) # empty dir
end

function init(package::String)
    path = Pkg.dir(package)
    isdir(path) || error("Unknown package $(package).")

    docpath = joinpath(path, "doc")
    if !isdir(docpath)
        info("Creating $(package)/doc.")
        mkdir(docpath)
    end

    helppath = joinpath(docpath, "help")
    if !isdir(helppath)
        info("Creating $(package)/doc/help.")
        mkdir(helppath)
    end

    open(joinpath(docpath, "docile.jl"), "w") do f
        write(f, """
        import Docile
        Docile.generate("$(package)")
        """)
    end
end

## Patch help system ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# TODO: Avoid this.
function patch!()
    info("Patching Base.Help.init_help()...")

    code = quote
        cache_dir = joinpath(Pkg.dir("Docile"), "cache")
        if isdir(cache_dir)
            for package in readdir(cache_dir)
                fn = joinpath(cache_dir, package, "helpdb.jl")
                isfile(fn) && append!(helpdb, evalfile(fn))
            end
        end
    end

    eval(Base.Help, quote

             function init_help()
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
