module EdgeCases

using Docile
@docstrings

@doc { :returns => (Int,) } ->
f(x) = x

end

let results = @query(EdgeCases.f(1))
    @test length(results) == 1
    mod, obj, ent = results.entries[1]
    @test docs(ent) == ""
    @test metadata(ent)[:returns] == (Int,)
end
