module Docile

import Base: triplequoted

using Base.Meta, Compat, Iterators

export @docstrings, @doc, @document, meta # Old exports.

export @commence, @conclude

### Bootstrap. ###

const __DOCUMENTED_MODULES__ = Set{Module}()

const META = :__METADATA__

const DEFAULT_OPTIONS = @compat Dict{Symbol, Any}(
    :format => :md,
    :manual => UTF8String[]
    )

"Stores a module's metadata."
type Metadata
    modname :: Module
    objects :: ObjectIdDict
    root    :: UTF8String
    files   :: Set{UTF8String}
    options :: Dict{Symbol, Any}

    function Metadata(root, options)
        options = merge(DEFAULT_OPTIONS, options)
        push!(__DOCUMENTED_MODULES__, current_module())
        new(current_module(), ObjectIdDict(), root, Set{UTF8String}(), options)
    end
end

# Capture metadata options.
macro options(args...) :(options($(map(esc, args)...))) end
options(; args...) = Dict{Symbol, Any}(args)

"Modified ``include`` that caches paths of included file in module's ``__METADATA__``."
include!(meta, path) = (pushfile!(meta, path); Base.include_from_node1(path))
pushfile!(meta, path) = push!(meta.files, fullpath(path, Base.source_path(nothing)))
fullpath(path, prev) = path ≡ nothing ? abspath(path) : joinpath(dirname(prev), path)

"Setup documentation for the current module. Place at start of module."
macro commence(options...)
    quote
        const $(esc(META)) = Metadata(@__FILE__, @options($(map(esc, options)...)))
        $(esc(:include)) = path -> include!($(esc(META)), path)
    end
end

"Build documentation for the current module. Place at end of module."
macro conclude()
    quote
        $(esc(:include)) = Base.include_from_node1
        builddocs!($(esc(META)))
    end
end
### End bootstrap. ###

@commence(manual = "../docs/manual.md")

include("method-lookup.jl")
include("builddocs.jl")

include("interpolate.jl")
include("types.jl")
include("macros.jl")
include("docstrings.jl")
include("interface.jl")

"""
Add additional metadata to a documented object.

`meta` takes arbitary keyword arguments and stores them internally as a `Dict{Symbol,Any}`.
The optional `doc` argument defaults to an empty string if not specified.

**Examples:**

The syntax previously used (in versions prior to `0.3.2`) was

```julia
@doc "Documentation goes here..." [ :returns => (Int,) ] ->
foobar(x) = 2x + 1

```

This now becomes

```julia
@doc meta("Documentation goes here...", returns = (Int,)) ->
foobar(x) = 2x + 1
```

Specifying an external file as documentation can be done in the following way:

```julia
@doc meta(file = "../my/external/file.md") ->
foobar(x) = 2x + 1
```

**Note:** the `file` path is relative to the current source file.
"""
meta(doc = ""; args...) = (doc, Dict{Symbol, Any}(args))

@conclude

end # module
