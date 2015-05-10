["Helper functions related to documentation and package metadata caching."]

"""
Find the most relevant metadata with key `key`.

Search path begins with the object `obj` itself, then the module's `ModuleData`,
followed by any parent `ModuleData` objects. Once `Main` is reached the
rootmodule's `PackageData` is searched.
"""
function findmeta(m::Module, obj, key::Symbol)
    # Stage 1: object's metadata.
    meta = getmeta(m, obj)
    haskey(meta, key) && return meta[key]

    # Stage 2: Module's metadata.
    local root
    while m != Main
        root = m
        meta = getmodule(m).metadata
        haskey(meta, key) && return meta[key]
        m = module_parent(m)
    end

    # Stage 3: Package's metadata.
    meta = getpackage(root).metadata
    haskey(meta, key) && return meta[key]

    # Give up!
    throw(ArgumentError("No metadata found for '$(key)'."))
end

"""
Parse raw docstrings in module `m` into their parsed form.

Also extracts additional embedded metadata found in each raw docstring.
"""
function parse!(m::Module)
    parsed = getdocs(m).parsed
    hasparsed(m) && return
    setparsed(m)
    for (obj, str) in getraw(m)
        parsed[obj] = extractor!(str, m, obj)
    end
end

"""
Extract metadata embedded in docstrings and run the `parsedocs` method defined
for the docstring `raw`.
"""
function extractor!(raw::AbstractString, m::Module, obj)
    str    = Formats.extractmeta!(raw, m, obj)
    format = findmeta(m, obj, :format)
    Formats.parsedocs(Formats.Format{format}(), str, m, obj)
end
