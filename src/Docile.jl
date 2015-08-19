"""
    Docile

> Documentation extensions for Julia.

"""
module Docile

include("Utilities.jl")
include(joinpath("Directives", "Directives.jl"))
include(joinpath("Docs", "Docs.jl"))

end # module
