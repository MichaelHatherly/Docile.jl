"""
    Directives
"""
module Directives

using Base.Meta, ..Utilities

export @D_str, build, directive, withdefault

include("builder.jl")
include("parser.jl")
include("extensions.jl")

end
