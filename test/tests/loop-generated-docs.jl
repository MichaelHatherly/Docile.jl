module LoopGeneratedDocs

using Docile

for (docs, meta, fn, T) in [
        ("# one\n*$(VERSION)*", 1, :foo, Int)
        ("## two",    2, :foo, Real)
        ("### three", 3, :foo, Float64)
        ("#### four", 4, :foo, Uint8)
        ]
    @eval @doc meta($docs, count = $meta) ->
    function $(fn)(x::$(T))
        x
    end
end
@doc "The generic function docs." -> foo

end

@test length(entries(documentation(LoopGeneratedDocs))) == 5
@test modulename(documentation(LoopGeneratedDocs)) === LoopGeneratedDocs
