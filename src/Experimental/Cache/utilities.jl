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
