module Docile

import Base: triplequoted
import Base.Meta: isexpr

export @docstrings, @doc

# internal
macro docref(ref)
    node = ref.args[end].args
    :($(esc(node[end])) = ($(node[1].args[1] + 1), @__FILE__))
end

include("interpolate.jl")
include("types.jl")
include("macros.jl")
include("docstrings.jl")
include("interface.jl")

@docstrings [ :manual => ["../doc/manual.md"] ]

# Add documentation manually.
for (cat, obj, ref, file) in [
        (:macro, symbol("@doc"),        REF_DOC,           "at-doc.md"),
        (:macro, symbol("@docstrings"), REF_DOCSTRINGS,    "at-docstrings.md"),
        (:macro, symbol("@md_str"),     REF_MD_STR,        "at-md-str.md"),
        (:macro, symbol("@md_mstr"),    REF_MD_MSTR,       "at-md-mstr.md"),
        (:type,  Documentation,         REF_DOCUMENTATION, "Documentation.md"),
        (:type,  Entry,                 REF_ENTRY,         "Entry.md")
        ]
    __METADATA__.entries[obj] = Entry{cat}(current_module(), ref, {:file => "../doc/objects/$(file)"})
end

end # module
