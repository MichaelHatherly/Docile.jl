module LoopGeneratedDocs

using Docile
@docstrings

for (docs, meta, fn, T) in [
        ("# one\n*$(VERSION)*", { :count => 1 }, :foo, Int)
        ("## two", { :count => 2 }, :foo, String)
        ("### three", { :count => 3 }, :foo, Float64)
        ("#### four", { :count => 4 }, :foo, Uint8)
        ]
    @eval @doc $docs $meta ->
    function $(fn)(x::$(T))
        x
    end
end
@doc "The generic function docs." -> foo

end

@test length(entries(documentation(LoopGeneratedDocs))) == 5
@test modulename(documentation(LoopGeneratedDocs)) === LoopGeneratedDocs
