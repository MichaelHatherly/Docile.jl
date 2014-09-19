using Docile, Docile.Interface
using Lexicon
using Base.Test

files = [
    "loop-generated-docs",
    "method-docs",
    "macro-spec",
    "at-doc-star",
    "interface",
    "old-tests",
    "docstring-macros",
    "interpolation",
    "edge-cases",
    "doctests"
    ]

for file in files
    println(" >>> Running tests in $(file).jl")
    include(joinpath("tests", "$(file).jl"))
end
