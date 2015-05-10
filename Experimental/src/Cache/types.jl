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

Base.empty!(d::DocsCache) = (empty!(d.raw); empty!(d.parsed); empty!(d.meta))
