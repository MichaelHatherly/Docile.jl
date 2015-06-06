# Docile.Formats


## Methods [Exported]

---

<a id="method__parsedocs.1" class="lexicon_definition"></a>
#### parsedocs(::Docile.Formats.Format{F<:Docile.Formats.AbstractFormatter},  raw,  mod,  obj) [¶](#method__parsedocs.1)
Parsing hook for docstring parsing.

Example:

    import Docile.Formats, Markdown
    const (fmt, md) = (Docile.Formats, Markdown)

    fmt.parsedocs(::fmt.Format{fmt.MarkdownFormatter}, raw, mod, obj) = md.parse(raw)

When registering a package the format is then provided to `PackageData`.

Arguments:

- `raw`: Unparsed docstring extracted from source code.
- `mod`: Module where the docstring and object are defined.
- `obj`: Object that the docstring is associated with.



*source:*
[Docile/src/Formats/formatting.jl:27](https://github.com/MichaelHatherly/Docile.jl/tree/1ea0a71f4a2ded1ccda0b5716a09050175a8e93e/src/Formats/formatting.jl#L27)


## Methods [Internal]

---

<a id="method__applymeta.1" class="lexicon_definition"></a>
#### applymeta(name,  body,  mod,  obj) [¶](#method__applymeta.1)
Apply nesting to body of metamacro when defined otherwise treat as raw text.


*source:*
[Docile/src/Formats/metaparse.jl:79](https://github.com/MichaelHatherly/Docile.jl/tree/1ea0a71f4a2ded1ccda0b5716a09050175a8e93e/src/Formats/metaparse.jl#L79)

---

<a id="method__extractmeta.1" class="lexicon_definition"></a>
#### extractmeta!(text::AbstractString,  mod::Module,  obj) [¶](#method__extractmeta.1)
Run all 'metamacros' found in a raw docstring and return the resulting string.


*source:*
[Docile/src/Formats/metaparse.jl:63](https://github.com/MichaelHatherly/Docile.jl/tree/1ea0a71f4a2ded1ccda0b5716a09050175a8e93e/src/Formats/metaparse.jl#L63)

---

<a id="method__isprefix.1" class="lexicon_definition"></a>
#### isprefix(io::IO,  chars) [¶](#method__isprefix.1)
Does the buffer `io` begin with the given prefix chars?


*source:*
[Docile/src/Formats/metaparse.jl:124](https://github.com/MichaelHatherly/Docile.jl/tree/1ea0a71f4a2ded1ccda0b5716a09050175a8e93e/src/Formats/metaparse.jl#L124)

---

<a id="method__isvalid.1" class="lexicon_definition"></a>
#### isvalid(s::AbstractString) [¶](#method__isvalid.1)
Check that a `MetaMacro`'s `name` is a valid identifier.

Throws a `MetaMacroNameError` if the string `s` is not valid.


*source:*
[Docile/src/Formats/metaparse.jl:28](https://github.com/MichaelHatherly/Docile.jl/tree/1ea0a71f4a2ded1ccda0b5716a09050175a8e93e/src/Formats/metaparse.jl#L28)

---

<a id="method__readbracketed.1" class="lexicon_definition"></a>
#### readbracketed(io::IO) [¶](#method__readbracketed.1)
Extract to a string the text between matching brackets `(` and `)`.

Throws a `ParseError` when unmatched brackets are encountered.


*source:*
[Docile/src/Formats/metaparse.jl:136](https://github.com/MichaelHatherly/Docile.jl/tree/1ea0a71f4a2ded1ccda0b5716a09050175a8e93e/src/Formats/metaparse.jl#L136)

---

<a id="method__tryextract.1" class="lexicon_definition"></a>
#### tryextract(io::IO) [¶](#method__tryextract.1)
Try extract an embedded metadata entry name from buffer at current position.

Returns the empty symbol `symbol("")` when the current position is not the start
of an embedded metadata entry.


*source:*
[Docile/src/Formats/metaparse.jl:97](https://github.com/MichaelHatherly/Docile.jl/tree/1ea0a71f4a2ded1ccda0b5716a09050175a8e93e/src/Formats/metaparse.jl#L97)

## Types [Internal]

---

<a id="type__metamacro.1" class="lexicon_definition"></a>
#### Docile.Formats.MetaMacro{name, raw} [¶](#type__metamacro.1)
Dispatch type for the `metamacro` function. `name` is a `Symbol`.

When ``raw == true`` the metamacro with identifier ``name`` with not behave as a
standard metamacro. Nesting will be disabled and must be implemented explicitly
using ``Docile.Formats.extractmeta!`` as follows:

    function Formats.metamacro(::META"name"raw, body, mod, obj)
        # ...
        body = Docile.Formats.extractmeta!(body, mod, obj)
        # ...
    end



*source:*
[Docile/src/Formats/metaparse.jl:17](https://github.com/MichaelHatherly/Docile.jl/tree/1ea0a71f4a2ded1ccda0b5716a09050175a8e93e/src/Formats/metaparse.jl#L17)

## Macros [Internal]

---

<a id="macro___meta_str.1" class="lexicon_definition"></a>
#### @META_str(args...) [¶](#macro___meta_str.1)
Shorthand syntax for defining `MetaMacro{<name>}`s as `META"<name>"`.

Example

    import Docile: Cache
    import Docile.Formats: metamacro, @META_str

    metamacro(::META"author", body, mod, obj) = isempty(body) ?
        Cache.findmeta(mod, obj, :author) :
        (Cache.getmeta(mod, obj)[:author = strip(body)]; "")

By default metamacros are 'nestable', which means that an author may
write metamacros within metamacros. In some cases this may not be the
behaviour that is desired. Nesting can be disabled on a per-definition
basis by using the ``raw`` modifier:

    metamacro(::META"name"raw, body, mod, obj) = ...



*source:*
[Docile/src/Formats/metaparse.jl:51](https://github.com/MichaelHatherly/Docile.jl/tree/1ea0a71f4a2ded1ccda0b5716a09050175a8e93e/src/Formats/metaparse.jl#L51)

