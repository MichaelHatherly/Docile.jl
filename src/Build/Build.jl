"""
    Build

Generate static markdown documentation from templated files.

**Module Exports:**

$(Utilities.exportlist(Build))
"""
module Build

using Base.Meta, ..Utilities, ..Docs, ..Directives

export makedocs

include("loadfile.jl")
include("makedocs.jl")
include("mkdocs.jl")

end
