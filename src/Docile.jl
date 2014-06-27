
"""
A package documentation package for Julia.

Docile can extract multiline strings from julia source files and
associated metadata to create several different human readable
documentation formats.
"""
module Docile

## Package dependancies –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

import Markdown

## Base imports –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

import Base: triplequoted, writemime
import Base.Meta: isexpr

## Exports ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

export
    @doc_mstr,
    build,
    helpdb,
    html,
    init,
    patch!,
    plain,
    remove

## Load files –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

include("utils.jl")
include("types.jl")

include("extract.jl")
include("render.jl")

include("interactive.jl")

include("interface.jl")

include("patch.jl")

end # module
