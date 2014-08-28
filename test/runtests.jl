using Docile
using Base.Test

include("macro-spec.jl")
include("method-docs.jl")
include("loop-generated-docs.jl")
include("old-tests.jl")

# fix reversed order in query macro
let results = @query doctest(Docile)
    @test length(results) == 1
    @test isa(results[1][1], Method)
    @test isa(results[1][2], Docile.Entry{:method})
end
