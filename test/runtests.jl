OS_NAME == :Windows && Pkg.add("FactCheck")

module DocileTests

using FactCheck, Compat, Base.Test, Docile


include("helpers.jl")
include("Legacy/facts.jl")
include("Collector/facts.jl")
include("Interface/facts.jl")
include("Runner/facts.jl")
include("Formats/facts.jl")

isinteractive() || FactCheck.exitstatus()

end
