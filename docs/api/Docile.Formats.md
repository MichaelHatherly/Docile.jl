# Docile.Formats


## Methods [Exported]

---

<a id="method__parsedocs.1" class="lexicon_definition"></a>
#### parsedocs(::Docile.Formats.Format{F<:Docile.Formats.AbstractFormatter}, raw, mod, obj) [¶](#method__parsedocs.1)
Parsing hook for docstring parsing.

Example:

    import Docile.Formats, Markdown
    const (fmt, md) = (Docile.Formats, Markdown)

    immutable MarkdownFormatter <: fmt.AbstractFormatter end

    fmt.parsedocs(::fmt.Format{MarkdownFormatter}, raw, mod, obj) = md.parse(raw)

When registering a package the format is then provided to `PackageData`.

Arguments:

- `raw`: Unparsed docstring extracted from source code.
- `mod`: Module where the docstring and object are defined.
- `obj`: Object that the docstring is associated with.



*source:*
[Docile/src/Formats/formatting.jl:28](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Formats/formatting.jl#L28)


## Methods [Internal]

---

<a id="method__extractmeta.1" class="lexicon_definition"></a>
#### extractmeta!(text::AbstractString, mod::Module, obj) [¶](#method__extractmeta.1)
Run all 'metamacros' found in a raw docstring and return the resulting string.


*source:*
[Docile/src/Formats/metaparse.jl:41](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Formats/metaparse.jl#L41)

---

<a id="method__isprefix.1" class="lexicon_definition"></a>
#### isprefix(io::IO, chars) [¶](#method__isprefix.1)
Does the buffer `io` begin with the given prefix chars?


*source:*
[Docile/src/Formats/metaparse.jl:91](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Formats/metaparse.jl#L91)

---

<a id="method__isvalid.1" class="lexicon_definition"></a>
#### isvalid(s::AbstractString) [¶](#method__isvalid.1)
Check that a `MetaMacro`'s `name` is a valid identifier.

Throws a `MetaMacroNameError` if the string `s` is not valid.


*source:*
[Docile/src/Formats/metaparse.jl:17](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Formats/metaparse.jl#L17)

---

<a id="method__readbracketed.1" class="lexicon_definition"></a>
#### readbracketed(io::IO) [¶](#method__readbracketed.1)
Extract to a string the text between matching brackets `(` and `)`.

Throws a `ParseError` when unmatched brackets are encountered.


*source:*
[Docile/src/Formats/metaparse.jl:103](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Formats/metaparse.jl#L103)

---

<a id="method__tryextract.1" class="lexicon_definition"></a>
#### tryextract(io::IO) [¶](#method__tryextract.1)
Try extract an embedded metadata entry name from buffer at current position.

Returns the empty symbol `symbol("")` when the current position is not the start
of an embedded metadata entry.


*source:*
[Docile/src/Formats/metaparse.jl:64](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Formats/metaparse.jl#L64)

## Types [Internal]

---

<a id="type__metamacro.1" class="lexicon_definition"></a>
#### Docile.Formats.MetaMacro{name} [¶](#type__metamacro.1)
Dispatch type for the `metamacro` function. `name` is a `Symbol`.


*source:*
[Docile/src/Formats/metaparse.jl:6](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Formats/metaparse.jl#L6)

## Macros [Internal]

---

<a id="macro___meta_str.1" class="lexicon_definition"></a>
#### @META_str(str) [¶](#macro___meta_str.1)
Shorthand syntax for defining `MetaMacro{<name>}`s as `META"<name>"`.

Example

    import Docile: Cache
    import Docile.Formats: metamacro, @META_str

    metamacro(::META"author", body, mod, obj) = isempty(body) ?
        Cache.findmeta(mod, obj, :author) :
        (Cache.getmeta(mod, obj)[:author = strip(body)]; "")



*source:*
[Docile/src/Formats/metaparse.jl:33](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Formats/metaparse.jl#L33)

## Comments [Internal]

---

<a id="comment__comment.1" class="lexicon_definition"></a>
#### Docile.Legacy.Comment(symbol("##comment#3522")) [¶](#comment__comment.1)
Extraction of metadata from docstrings prior to formatting them.

