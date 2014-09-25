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

@doc* md"$x"i {
    :result => "1"
    } ->
h(x) = x

end

for fn in [:f, :g, :h]
    results = query(getfield(Interpolation, fn))
    @test length(results.categories) == 1
    ent, obj = first(results.categories[:function].entries)
    @test docs(ent) == metadata(ent)[:result]
end

@test_throws ParseError Docile.interpolate("\$(1 + 2 + (")
