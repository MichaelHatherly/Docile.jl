["Types related to docstring caching."]

"""
For a single module store raw docstrings, parsed docs, and metadata.
"""
type DocsCache
    raw    :: ObjectIdDict
    parsed :: ObjectIdDict
    meta   :: ObjectIdDict

    DocsCache(raw, meta) = new(raw, ObjectIdDict(), meta)
end

type GlobalCache
    base     :: Bool
    loaded   :: Set{UTF8String}
    parsed   :: Set{Module}
    packages :: Dict{Module, PackageData}
    modules  :: Dict{Module, ModuleData}
    docs     :: Dict{Module, DocsCache}

    GlobalCache(base = true) = new(
        base, Set{UTF8String}(), Set{Module}(),
        Dict{Module, PackageData}(),
        Dict{Module, ModuleData}(),
        Dict{Module, DocsCache}()
        )
end

function Base.empty!(cache::GlobalCache)
    for each in (:loaded, :parsed, :packages, :modules, :docs)
        empty!(getfield(cache, each))
    end
end

togglebase(cache::GlobalCache) = cache.base = !cache.base

function update!(cache::GlobalCache)
    diff   = Set{UTF8String}()
    loaded = Set{UTF8String}(keys(Base.package_list))
    # Do we want to include ``Base`` in the cache?
    cache.base && push!(loaded, Utilities.expandpath("sysimg.jl"))
    # Find newly added packages.
    if length(loaded) > length(cache.loaded)
        Utilities.message("updating package list...")
        diff = setdiff(loaded, cache.loaded)
        # Update the loaded packages list.
        cache.loaded = loaded
    end
    # Update the package and module caches.
    for (rootmodule, package) in Collector.findpackages(diff)
        haspackage(cache, rootmodule) && warn("Overwriting package '$(rootmodule)'.")
        for (m, data) in package.modules
            cache.modules[m] = data
        end
        cache.packages[rootmodule] = package
    end
end

function loadedmodules(cache::GlobalCache)
    update!(cache)
    Set{Module}(keys(cache.modules))
end

