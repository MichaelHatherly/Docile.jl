module Docile

import Base: triplequoted, push!
import Base.Meta: isexpr

export @docstrings, @doc

# internal
macro docref(ref)
    node = ref.args[end].args
    :($(esc(node[end])) = ($(node[1].args[1] + 1), @__FILE__))
end

include("interpolate.jl")
include("docstrings.jl")
include("types.jl")
include("macros.jl")

@docstrings [ :manual => ["../doc/manual.md"] ]

macro tex_mstr(text)
    Base.warn_once("""
    @tex_mstr has be deprecated in favour of typed docstrings and will
    be removed in version 0.3.0.
    
    Use @md_str and @md_mstr when needing to avoid interpolation.
    """)
    triplequoted(text)
end

include("interface.jl")

# Add documentation manually.
for (cat, obj, ref, file) in [
        (:macro, symbol("@doc"),        REF_DOC,           "at-doc.md"),
        (:macro, symbol("@docstrings"), REF_DOCSTRINGS,    "at-docstrings.md"),
        (:macro, symbol("@md_str"),     REF_MD_STR,        "at-md-str.md"),
        (:macro, symbol("@md_mstr"),    REF_MD_MSTR,       "at-md-mstr.md"),
        (:type,  Documentation,         REF_DOCUMENTATION, "Documentation.md"),
        (:type,  Entry,                 REF_ENTRY,         "Entry.md")
        ]
    __METADATA__.entries[obj] = Entry{cat}(ref, __METADATA__, {:file => "../doc/objects/$(file)"})
end

end # module
