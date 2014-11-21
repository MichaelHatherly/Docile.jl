module Interpolation

using Docile

x, y = 1, 2

@doc* meta(md"$x + $y = $(x + y)", result = "\$x + \$y = \$(x + y)") ->
f(x) = x

@doc* meta(md"$x + $y = $(x + y)"i, result = "$x + $y = $(x + y)") ->
g(x) = x

@doc* meta(md"$x"i, result = "1") ->
h(x) = x

end

for fn in [:f, :g, :h]
    results = query(getfield(Interpolation, fn))
    @test length(results.categories) == 1
    ent, obj = first(results.categories[:function].entries)
    @test data(docs(ent)) == metadata(ent)[:result]
end

@test_throws ParseError Docile.interpolate("\$(1 + 2 + (")
