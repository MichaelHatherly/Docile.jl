"""
    Docs

Provides docstring hooks for modifying the behaviour of Julia's documentation system.

**Module Exports:**

$(Utilities.exportlist(Docs))
"""
module Docs

using ..Utilities
using ..Directives
using Base.Meta

include("hooks.jl")
include("extensions.jl")

end
