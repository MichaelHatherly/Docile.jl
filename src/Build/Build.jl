"""
    Build

Generate static markdown documentation from templated files.

**Module Exports:**

$(Utilities.exportlist(Build))
"""
module Build

using Base.Meta, ..Utilities

import ..Docs: Root, process!

include("makedocs.jl")
include("mkdocs.jl")

end
