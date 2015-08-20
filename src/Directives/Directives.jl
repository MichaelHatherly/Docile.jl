"""
    Directives

Run arbitrary user-defined code inside documentation.

**Module Exports:**

$(Utilities.exportlist(Directives))
"""
module Directives

using Base.Meta, ..Utilities

export @D_str, build, directive, withdefault

include("builder.jl")
include("parser.jl")
include("extensions.jl")

end
