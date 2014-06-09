## User interface –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

function build(packages::String...)
    isempty(packages) && (packages = readdir(CACHE_DIR))
    for package in packages
        cachedocs(package, getdocs(package))
    end
    Base.Help.clear_cache()
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

function remove(package::String)
    path = joinpath(Pkg.dir(package), "doc")
    config = joinpath(path, "docile.jl")
    isfile(config) || error("$(package) is not setup for Docile.")

    warn("Removing Docile from $(package).")

    rm(config)

    helppath = joinpath(path, "help")
    isdir(helppath) && _recursive_rm(helppath)

    isempty(readdir(path)) && rmdir(path)

    dbpath = joinpath(CACHE_DIR, package)
    if isdir(dbpath)
        warn("Removing cache for $(package).")
        _recursive_rm(dbpath)
    else
        info("No cache found for $(package).")
    end
end

## Utils ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

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
