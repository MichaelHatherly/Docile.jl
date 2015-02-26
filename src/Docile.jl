module Docile

import Base: triplequoted, copy

using Base.Meta, Compat

export @document, @file_str, @docstrings, @doc, @comment, meta

## Start Bootstrap. ---------------------------------------------------------------------

const DOCUMENTED = Set{Module}()
const METADATA   = :__METADATA__

"Register a module `modname` as 'documented' with Docile."
register!(modname) = push!(DOCUMENTED, modname)

"""
Container type used to store a module's metadata collected by Docile.

Each module documented using Docile contains an instance of this object created
using the `@document` macro.

**Fields:**

* `modname`: The module where this object is defined.
* `entries`: Dictionary containing `object => Entry` pairs.
* `root`: The full directory path to a module's location.
* `files`: Set of all files `include`d in a module.
* `data`: Additional metadata collected during module parsing.
* `loaded`: Has the module been parsed and metadata collected?
"""
type Metadata
    modname :: Module
    entries :: ObjectIdDict
    root    :: UTF8String
    files   :: Set{UTF8String}
    data    :: Dict{Symbol, Any}
    loaded  :: Bool
end

"""
Convenience constructor for `Metadata` type that initializes default values for
most of the type's fields.
"""
function Metadata(root::AbstractString, data::Dict)
    @assert isfile(root) "`@document` can only be used in files. REPL usage is unsupported."
    register!(current_module())
    data = merge(@compat(Dict(:format   => :md,
                              :loopdocs => false,
                              :manual   => UTF8String[]
                              )), data)
    Metadata(current_module(), ObjectIdDict(), root, Set{UTF8String}(), data, false)
end

# Capture metadata options.
macro options(args...) :(options($(map(esc, args)...))) end
options(; args...) = Dict{Symbol, Any}(args)

"""
Method used to override the behavior of `include`.

`include!` caches the full path of the included file in a module's `Metadata`
object and then passes `path` argument onto `Base.include_from_node1` method
as with the usual behavior of `Base.include`.
"""
function include!(meta, path)
    pushfile!(meta, path)
    Base.include_from_node1(path)
end
pushfile!(meta, path) = push!(meta.files, fullpath(path, Base.source_path(nothing)))
fullpath(path, prev)  = path ≡ nothing ? abspath(path) : joinpath(dirname(prev), path)

"""
Macro used to setup documentation for the current module.

Keyword arguments may be given to either override default module-level
metadata or to provide additional key/value pairs.

**Examples:**

```julia
using Docile
@document

```

```julia
using Docile
@document(manual = ["../docs/manual.md"])

```
"""
macro document(options...)
    quote
        const $(esc(METADATA)) = Metadata(@__FILE__, @options($(map(esc, options)...)))
        $(esc(:include)) = path -> include!($(esc(METADATA)), path)
    end
end

## End Bootstrap. -----------------------------------------------------------------------

@document

include("method-lookup.jl")
include("builddocs.jl")

include("interpolate.jl")
include("types.jl")
include("macros.jl")
include("docstrings.jl")
include("interface.jl")

end # module
