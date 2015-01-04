module Docile

import Base: triplequoted

using Base.Meta, Compat

export @document, @docstrings, @doc, meta

## Start Bootstrap. ---------------------------------------------------------------------

const DOCUMENTED = Set{Module}()
const METADATA   = :__METADATA__

"Register a module `modname` as 'documented' with Docile."
register!(modname) = push!(DOCUMENTED, modname)

"Store a module's metadata."
type Metadata
    modname :: Module
    entries :: ObjectIdDict
    root    :: UTF8String
    files   :: Set{UTF8String}
    data    :: Dict{Symbol, Any}
    loaded  :: Bool
end

function Metadata(root::AbstractString, data::Dict)
    register!(current_module())
    data = merge(@compat(Dict(:format => :md, :manual => UTF8String[])), data)
    Metadata(current_module(), ObjectIdDict(), root, Set{UTF8String}(), data, false)
end

# Capture metadata options.
macro options(args...) :(options($(map(esc, args)...))) end
options(; args...) = Dict{Symbol, Any}(args)

"Modified ``include`` that caches path of included file in module's ``__METADATA__``."
function include!(meta, path)
    pushfile!(meta, path)
    Base.include_from_node1(path)
end
pushfile!(meta, path) = push!(meta.files, fullpath(path, Base.source_path(nothing)))
fullpath(path, prev)  = path ≡ nothing ? abspath(path) : joinpath(dirname(prev), path)

"Document the current module."
macro document(options...)
    quote
        const $(esc(METADATA)) = Metadata(@__FILE__, @options($(map(esc, options)...)))
        $(esc(:include)) = path -> include!($(esc(METADATA)), path)
    end
end

## End Bootstrap. -----------------------------------------------------------------------

@document(manual = ["../docs/manual.md"])

include("method-lookup.jl")
include("builddocs.jl")

include("interpolate.jl")
include("types.jl")
include("macros.jl")
include("docstrings.jl")
include("interface.jl")

end # module
