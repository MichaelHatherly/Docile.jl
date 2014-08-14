module Docile

import AnsiColor, Markdown

import Base: triplequoted, writemime, push!
import Base.Meta: isexpr

export query, doctest, @query, @doc, @docstrings, @tex_mstr

include("types.jl")
include("docstrings.jl")

# Initialise docstrings for this module. Can't document previous files
# since they define the docstring methods/macros.
@docstrings

include("render.jl")
include("doctest.jl")
include("query.jl")

# link the readme into the package docs
@doc [ :file => "../README.md" ] .. Docile

end # module
