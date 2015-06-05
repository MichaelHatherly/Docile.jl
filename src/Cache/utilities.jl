["Helper functions related to documentation and package metadata caching."]

function findmeta(cache::GlobalCache, m::Module, obj, key::Symbol, T)
    # Stage 1: object's metadata.
    meta = getmeta(cache, m, obj)
    haskey(meta, key) && return Nullable{T}(meta[key])

    # Stage 2: Module's metadata.
    local root
    while m != Main
        root = m
        meta = getmodule(cache, m).metadata
        haskey(meta, key) && return Nullable{T}(meta[key])
        m = module_parent(m)
    end

    # Stage 3: Package's metadata.
    meta = getpackage(cache, root).metadata
    haskey(meta, key) && return Nullable{T}(meta[key])

    # Give up!
    Nullable{T}()
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
    str   = Formats.extractmeta!(raw, m, obj)
    value = findmeta(cache, m, obj, :format, DataType)
    fmt   = isnull(value) ? Formats.MarkdownFormatter : get(value)
    Formats.parsedocs(Formats.Format{fmt}(), str, m, obj)
end
