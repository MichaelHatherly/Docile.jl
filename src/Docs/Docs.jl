"""
    Docs

Provides docstring hooks for modifying the behaviour of Julia's documentation system.

**Module Exports:**

$(Utilities.exportlist(Docs))
"""
module Docs

using Base.Meta, ..Utilities

include("hooks.jl")
include("parser.jl")
include("doctypes.jl")
include("directives.jl")
include("process.jl")
include("display.jl")

end
