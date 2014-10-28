module DocstringMacros

using Docile
@docstrings

@doc* md"x + y = $(1 + 1)" [
    :result => "x + y = \$(1 + 1)"
    ] ->
f(x) = x

@doc* md"x + y = $(1 + 1)"i [
    :result => "x + y = 2"
    ] ->
g(x) = x

@doc* md"""
$(1 + (sin(3) + 1))
""" [
    :result => "\$(1 + (sin(3) + 1))\n"
    ] ->
h(x) = x

@doc* md"""
$(1 + (sin(3) + 1))
"""i [
    :result => "2.1411200080598674\n"
    ] ->
j(x) = x

end

for fn in [:f, :g, :h, :j]
    results = query(getfield(DocstringMacros, fn))
    @test length(results.categories) == 1
    ent, obj = first(results.categories[:function].entries)
    @test data(docs(ent)) == metadata(ent)[:result]
end
