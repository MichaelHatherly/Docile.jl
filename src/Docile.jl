module Docile

import Base: triplequoted
import Base.Meta: isexpr

using Compat

export @docstrings, @doc, meta

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

@docstrings(manual = ["../doc/manual.md"])

@doc """
Add additional metadata to a documented object.

`meta` takes arbitary keyword arguments and stores them internally as a `Dict{Symbol,Any}`.
The optional `doc` argument defaults to an empty string if not specified.

**Examples:**

The syntax previously used (in versions prior to `0.3.2`) was

```julia
@doc "Documentation goes here..." [ :returns => (Int,) ] ->
foobar(x) = 2x + 1

```

This now becomes

```julia
@doc meta("Documentation goes here...", returns = (Int,)) ->
foobar(x) = 2x + 1
```

Specifying an external file as documentation can be done in the following way:

```julia
@doc meta(file = "../my/external/file.md") ->
foobar(x) = 2x + 1
```

**Note:** the `file` path is relative to the current source file.
""" ->
meta(doc = ""; args...) = (doc, Dict{Symbol, Any}(args))

# Add other documentation manually.
for (cat, obj, ref, file) in [
        (:macro, symbol("@doc"),        REF_DOC,           "at-doc.md"),
        (:macro, symbol("@docstrings"), REF_DOCSTRINGS,    "at-docstrings.md"),
        (:macro, symbol("@md_str"),     REF_MD_STR,        "at-md-str.md"),
        (:macro, symbol("@md_mstr"),    REF_MD_MSTR,       "at-md-mstr.md"),
        (:type,  Documentation,         REF_DOCUMENTATION, "Documentation.md"),
        (:type,  Entry,                 REF_ENTRY,         "Entry.md")
        ]
    __METADATA__.entries[obj] = Entry{cat}(current_module(), ref, meta(file = "../doc/objects/$(file)"))
end

end # module
