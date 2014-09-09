module Docile

import AnsiColor, Markdown

import Base: triplequoted, writemime, push!, length
import Base.Meta: isexpr

export 
    query, @query,
    @doc, @docstrings, @tex_mstr,
    doctest, passed, failed, skipped, Summary, save, manual

# internal
macro docref(ref)
    node = ref.args[end].args
    :($(esc(node[end])) = ($(node[1].args[1] + 1), @__FILE__))
end

include("types.jl")
include("docstrings.jl")

# Initialise docstrings for this module. Can't document previous files
# since they define the docstring methods/macros.
@docstrings {"../doc/manual.md"}

include("render.jl")
include("doctest.jl")
include("query.jl")

include("docs.jl")

end # module
