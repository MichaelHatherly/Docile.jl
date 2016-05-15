OS_NAME == :Windows && Pkg.add("FactCheck")

using FactCheck, Compat, Base.Test, Docile

import Compat.String

include("helpers.jl")
VERSION < v"0.4-dev+6619" && include(joinpath("Legacy", "facts.jl"))
include(joinpath("Collector", "facts.jl"))
include(joinpath("Interface", "facts.jl"))
include(joinpath("Runner", "facts.jl"))
include(joinpath("Formats", "facts.jl"))
include(joinpath("Extensions", "facts.jl"))

isinteractive() || FactCheck.exitstatus()
