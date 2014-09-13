using Docile, Docile.Interface
using Base.Test

files = [
    "loop-generated-docs",
    "method-docs",
    "macro-spec",
    "interface",
    "old-tests"
    ]

for file in files
    println(" >>> Running tests in $(file).jl")
    include(joinpath("tests", "$(file).jl"))
end
