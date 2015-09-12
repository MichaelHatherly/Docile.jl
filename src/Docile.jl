"""
$(moduleheader())

Documentation extensions for Julia.

$(exports())
"""
module Docile

include("Utilities.jl")
include("Parser.jl")
include("DocTree.jl")
include("Builder.jl")
include("Hooks.jl")
include("Tester.jl")
include("Queries.jl")

import .Hooks: register!
export register!, Hooks

import .Builder: makedocs
export makedocs

import .Tester: doctest, details
export doctest, details

end
