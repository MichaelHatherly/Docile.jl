["Helper functions related to documentation and package metadata caching."]

function findmeta(cache::GlobalCache, m::Module, obj, key::Symbol)
    # Stage 1: object's metadata.
    meta = getmeta(cache, m, obj)
    haskey(meta, key) && return meta[key]

    # Stage 2: Module's metadata.
    local root
    while m != Main
        root = m
        meta = getmodule(cache, m).metadata
        haskey(meta, key) && return meta[key]
        m = module_parent(m)
    end

    # Stage 3: Package's metadata.
    meta = getpackage(cache, root).metadata
    haskey(meta, key) && return meta[key]

    # Give up!
    throw(ArgumentError("No metadata found for '$(key)'."))
end

"""
Parse raw docstrings in module `m` into their parsed form.

Also extracts additional embedded metadata found in each raw docstring.
"""
function parse!(cache::GlobalCache, m::Module)
    parsed = getdocs(cache, m).parsed
    hasparsed(cache, m) && return
    setparsed(cache, m)
    for (obj, str) in getraw(m)
        parsed[obj] = extractor!(cache, str, m, obj)
    end
end

"""
Extract metadata embedded in docstrings and run the `parsedocs` method defined
for the docstring `raw`.
"""
function extractor!(cache::GlobalCache, raw::AbstractString, m::Module, obj)
    str    = Formats.extractmeta!(raw, m, obj)
    format = findmeta(cache, m, obj, :format)
    Formats.parsedocs(Formats.Format{format}(), str, m, obj)
end
