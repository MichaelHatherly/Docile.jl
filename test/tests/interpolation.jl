module Interpolation

using Docile
@docstrings

x, y = 1, 2

@doc* md"$x + $y = $(x + y)" {
    :result => "\$x + \$y = \$(x + y)"
    } ->
f(x) = x

@doc* md"$x + $y = $(x + y)"i {
    :result => "$x + $y = $(x + y)"
    } ->
g(x) = x

end

for fn in [:f, :g]
    results = query(getfield(Interpolation, fn))
    @test length(results) == 1
    mod, obj, ent = results.entries[1]
    @test docs(ent) == metadata(ent)[:result]
end

@test_throws ParseError Docile.interpolate("\$(1 + 2 + (")
