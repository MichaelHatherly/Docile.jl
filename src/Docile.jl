module Docile

import AnsiColor, Markdown

import Base: triplequoted, writemime, push!
import Base.Meta: isexpr

export query, doctest, @query, @doc, @docstrings, @tex_mstr

# internal
macro docref(ref)
    node = ref.args[end].args
    :($(esc(node[end])) = ($(node[1].args[1] + 1), @__FILE__))
end

include("types.jl")
include("docstrings.jl")

# Initialise docstrings for this module. Can't document previous files
# since they define the docstring methods/macros.
@docstrings

include("render.jl")
include("doctest.jl")
include("query.jl")

# link the readme into the package docs
@doc { :file => "../README.md" } -> Docile

include("docs.jl")

end # module
