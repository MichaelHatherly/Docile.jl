using Docile
using Base.Test

include("macro-spec.jl")
include("method-docs.jl")
include("loop-generated-docs.jl")
include("doctests.jl")
include("queries.jl")
include("old-tests.jl")

# fix reversed order in query macro
let results = @query doctest(Docile)
    @test length(results) == 1
    @test isa(results.entries[1][1], Method)
    @test isa(results.entries[1][2], Docile.Entry{:method})
end

# doctest summary tests
doctest_summary = doctest(Docile)
writemime(STDOUT, "text/plain", doctest_summary)

# save html and cleanup after
let filename = string(tempname(), ".html")
    save(filename, Docile)
    rm(filename)
end
