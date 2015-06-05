["Global documentation cache getters and setters."]

## Package and Module Data. ##

function hasmodule(cache::GlobalCache, m::Module)
    haskey(cache.modules, m) && return true
    update!(cache)
    haskey(cache.modules, m)
end

function getmodule(cache::GlobalCache, m::Module)
    hasmodule(cache, m) && return cache.modules[m]
    p = m
    while p != Main
        haspackage(cache, p) && return cache.modules[m]
        p = module_parent(p)
    end
    throw(ArgumentError("No module '$(m)' currently cached."))
end

function haspackage(cache::GlobalCache, m::Module)
    haskey(cache.packages, m) && return true
    update!(cache)
    haskey(cache.packages, m)
end

function getpackage(cache::GlobalCache, m::Module)
    mod = m
    while m != Main
        haspackage(cache, m) && return cache.packages[m]
        m = module_parent(m)
    end
    throw(ArgumentError("'$(mod)' is not a cached package."))
end

hasparsed(cache::GlobalCache, m::Module) = m ∈ cache.parsed

setparsed(cache::GlobalCache, m::Module) = push!(cache.parsed, m)

function initdocs!(cache::GlobalCache, m::Module)
    package = getpackage(cache, m)
    total   = length(package.modules)
    text    = string(total, " module", total > 1 ? "s" : "")
    Utilities.message("caching $(text) from '$(package.rootmodule)'.")
    for (modulename, data) in package.modules
        raw, meta = Collector.docstrings(data)
        cache.docs[modulename] = DocsCache(raw, meta)
    end
end

hasdocs(cache::GlobalCache, m::Module) = haskey(cache.docs, m)

function getdocs(cache::GlobalCache, m::Module)
    hasdocs(cache, m) || initdocs!(cache, m)
    cache.docs[m]
end

## Raw docstrings. ##

getraw(cache::GlobalCache, m::Module) = getdocs(cache, m).raw

function getraw(cache::GlobalCache, m::Module, obj)
    raw = getraw(cache, m)
    haskey(raw, obj) || throw(ArgumentError("'$(obj)' not found in '$(m)'."))
    raw[obj]
end

## Parsed docstrings. ##

function getparsed(cache::GlobalCache, m::Module)
    parse!(cache, m)
    getdocs(cache, m).parsed
end

function getparsed(cache::GlobalCache, m::Module, obj)
    parsed = getparsed(cache, m)
    haskey(parsed, obj) || throw(ArgumentError("'$(obj)' not found."))
    parsed[obj]
end

## Metadata. ##

getmeta(obj::Union(ModuleData, PackageData)) = obj.metadata

function getmeta(cache::GlobalCache, m::Module)
    parse!(cache, m)
    getdocs(cache, m).meta
end

function getmeta(cache::GlobalCache, m::Module, obj)
    meta = getmeta(cache, m)
    haskey(meta, obj) || throw(ArgumentError("'$(obj)' not found."))
    meta[obj]::Dict{Symbol, Any}
end

## Misc. ##

objects(cache::GlobalCache, m::Module) = collect(keys(getraw(cache, m)))

