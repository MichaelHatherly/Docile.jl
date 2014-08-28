module LoopGeneratedDocs

using Docile
@docstrings

for (docs, meta, fn, T) in [
        ("# one\n*$(VERSION)*", { :count => rand() }, :foo, Int)
        ("## two", { :count => rand() }, :foo, String)
        ("### three", { :count => rand() }, :foo, Float64)
        ("#### four", { :count => rand() }, :foo, Uint8)
        ]
    @eval @doc $docs $meta ->
    function $(fn)(x::$(T))
        x
    end
end
@doc "The generic function docs." -> foo

end

@assert length(Docile.query(LoopGeneratedDocs.foo)) == 5
