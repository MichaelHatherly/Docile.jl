
"""
Extract doc strings from all source files in `package`. Generate
formatted documentation using the settings specified in `config`.
"""
function build(package::String, config::Dict)
    package_exists(package)
    source = joinpath(Pkg.dir(package), "src", package * ".jl")
    isfile(source) || error("Cannot find starting file $(source). Stopping.")
    docs = extract(source)
    for output in config[:output]
        output(package, docs)
    end
    info("Finished building documentation for $(package).")
end

"""
Setup Docile for specified `package`. Creates a `docs/` folder if
needed, as well as a default config file that can be used to run Docile
for the `package`.
"""
function init(package::String)
    package_exists(package)
    docpath = joinpath(Pkg.dir(package), "doc")
    if !isdir(docpath)
        info("Creating doc directory for $(package)")
        mkdir(docpath)
    end
    open(joinpath(docpath, "docile.jl"), "w") do f
        print(f, """
        using Docile

        config = [
            :output => [plain, html, helpdb]
        ]

        Docile.build("$(package)", config)
        """)
    end
    info("Finished initialising Docile for $(package).")
end

"""
Remove Docile from `package`. The cache folder for the `package` and the
config file are deleted.
"""
function remove(package::String)
    package_exists(package)
    cachedir = joinpath(CACHE_DIR, package)
    isdir(cachedir) && (info("Removing cache."); rm(cachedir; recursive=true))
    docpath = joinpath(Pkg.dir("Docile"), "doc")
    config_file = joinpath(docpath, "docile.jl")
    isfile(config_file) && (info("Removing config."); rm(config_file))
    if isdir(docpath) && isempty(readdir(docpath))
        info("Removing empty doc/ folder from $(package).")
        rm(docpath)
    end
    info("Finished removing Docile from $(package).")
end

package_exists(package::String) =
    (isdir(Pkg.dir(package)) || error("Cannot find package $(package)."))
