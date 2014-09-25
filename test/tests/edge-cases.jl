module EdgeCases

using Docile
@docstrings

@doc { :returns => (Int,) } ->
f(x) = x

end

let results = @query(EdgeCases.f(1))
    @test length(results.categories) == 1
    ent, obj = first(results.categories[:method].entries)
    @test data(docs(ent)) == ""
    @test metadata(ent)[:returns] == (Int,)
end
