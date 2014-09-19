module Docile

import Base: triplequoted, push!
import Base.Meta: isexpr

export @docstrings, @doc, @tex_mstr

# internal
macro docref(ref)
    node = ref.args[end].args
    :($(esc(node[end])) = ($(node[1].args[1] + 1), @__FILE__))
end

include("types.jl")
include("macros.jl")

@docstrings [
    :manual => ["../doc/manual.md"]
    ]

@doc """
A convenience string macro to allow LaTeX-like syntax to be used in
docstrings in the following manner:

```julia
@docstrings

@doc tex\"\"\"
Some inline maths: \\( x * y \\in G \\forall x, y \\in G \\) and some display
equations:

\\[
\\int_a^b f(x) \\, dx = F(b) - F(a)
\\]

\"\"\" ->
f(x) = x
```
""" ->
macro tex_mstr(text)
    triplequoted(text)
end

include("interface.jl")

# Add other documentation manually.
for (cat, obj, ref, file) in [
        (:macro, symbol("@doc"),        REF_DOC,           "at-doc.md"),
        (:macro, symbol("@docstrings"), REF_DOCSTRINGS,    "at-docstrings.md"),
        (:type,  Documentation,         REF_DOCUMENTATION, "Documentation.md"),
        (:type,  Entry,                 REF_ENTRY,         "Entry.md")
        ]
    __METADATA__.entries[obj] = Entry{cat}(ref, __METADATA__, {:file => "../doc/objects/$(file)"})
end

end # module
