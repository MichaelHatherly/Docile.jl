OS_NAME == :Windows && Pkg.add("FactCheck")

using FactCheck, Compat, Base.Test, Docile


include("helpers.jl")
include(joinpath("Legacy", "facts.jl"))
include(joinpath("Collector", "facts.jl"))
include(joinpath("Interface", "facts.jl"))
include(joinpath("Runner", "facts.jl"))
include(joinpath("Formats", "facts.jl"))
include(joinpath("Extensions", "facts.jl"))

isinteractive() || FactCheck.exitstatus()
