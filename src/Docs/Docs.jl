"""
    Docs

> Provides docstring hooks for modifying the behaviour of the Julia documentation system.

"""
module Docs

using ..Utilities
using ..Directives
using Base.Meta

include("hooks.jl")
include("extensions.jl")

end
