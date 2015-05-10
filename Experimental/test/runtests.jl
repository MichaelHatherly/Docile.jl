module DocileTests

using FactCheck, Compat, Base.Test, Docile

include("Formats/facts.jl")

isinteractive() || FactCheck.exitstatus()

end
