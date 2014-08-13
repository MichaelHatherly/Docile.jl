module Docile

import AnsiColor, Markdown, YAML

import Base: triplequoted, writemime

export query, doctest, (..), @query, @doc, @docstrings

const METADATA = :__METADATA__

include("types.jl")
include("docstrings.jl")

# Initialise docstrings for this module. Can't document previous files
# since they define the docstring methods/macros.
@docstrings

include("render.jl")
include("doctest.jl")
include("query.jl")

end # module
