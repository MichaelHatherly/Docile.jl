# Docile.Interface

Utility methods for working with `Entry` and `Metadata` types from the `Docile`
module (documentation available [here](api/Docile)).


## Methods [Exported]

---

<a id="method__category.1" class="lexicon_definition"></a>
#### category{C}(e::Docile.Entry{C}) [¶](#method__category.1)
Symbol representing the category that an `Entry` belongs to.


*source:*
[Docile/src/interface.jl:147](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L147)

---

<a id="method__data.1" class="lexicon_definition"></a>
#### data(d::Docile.Docs{format}) [¶](#method__data.1)
The raw content stored in a docstring.


*source:*
[Docile/src/interface.jl:171](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L171)

---

<a id="method__docs.1" class="lexicon_definition"></a>
#### docs(e::Docile.Entry{category}) [¶](#method__docs.1)
Documentation related to the entry.


*source:*
[Docile/src/interface.jl:162](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L162)

---

<a id="method__documented.1" class="lexicon_definition"></a>
#### documented() [¶](#method__documented.1)
Returns the modules that are currently documented by Docile.


*source:*
[Docile/src/interface.jl:41](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L41)

---

<a id="method__entries.1" class="lexicon_definition"></a>
#### entries(meta::Docile.Metadata) [¶](#method__entries.1)
Dictionary associating objects and documentation entries.


*source:*
[Docile/src/interface.jl:86](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L86)

---

<a id="method__files.1" class="lexicon_definition"></a>
#### files(meta::Docile.Metadata) [¶](#method__files.1)
All files `include`d in the module documented with the `meta` object.


*source:*
[Docile/src/interface.jl:96](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L96)

---

<a id="method__format.1" class="lexicon_definition"></a>
#### format{F}(d::Docile.Docs{F}) [¶](#method__format.1)
Return the format that a docstring is written in.


*source:*
[Docile/src/interface.jl:176](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L176)

---

<a id="method__isdocumented.1" class="lexicon_definition"></a>
#### isdocumented(mod::Module) [¶](#method__isdocumented.1)
Is the given module `modname` documented using Docile?


*source:*
[Docile/src/interface.jl:46](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L46)

---

<a id="method__isexported.1" class="lexicon_definition"></a>
#### isexported(modname::Module, object) [¶](#method__isexported.1)
Check whether `object` has been exported from a *documented* module `modname`.


*source:*
[Docile/src/interface.jl:111](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L111)

---

<a id="method__isloaded.1" class="lexicon_definition"></a>
#### isloaded(meta::Docile.Metadata) [¶](#method__isloaded.1)
Has the documentation contained in a module been loaded into the `meta` object?


*source:*
[Docile/src/interface.jl:101](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L101)

---

<a id="method__manual.1" class="lexicon_definition"></a>
#### manual(meta::Docile.Metadata) [¶](#method__manual.1)
The `Manual` object containing a module's manual pages.


*source:*
[Docile/src/interface.jl:81](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L81)

---

<a id="method__metadata.1" class="lexicon_definition"></a>
#### metadata(e::Docile.Entry{category}) [¶](#method__metadata.1)
Dictionary containing arbitrary metadata related to an entry.


*source:*
[Docile/src/interface.jl:157](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L157)

---

<a id="method__metadata.2" class="lexicon_definition"></a>
#### metadata(meta::Docile.Metadata) [¶](#method__metadata.2)
A dictionary containing configuration settings related to the `meta` object.


*source:*
[Docile/src/interface.jl:106](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L106)

---

<a id="method__metadata.3" class="lexicon_definition"></a>
#### metadata(mod::Module) [¶](#method__metadata.3)
Returns the `Metadata` object stored in a module `modname` by Docile.

Throws an `ArgumentError` when the module has not been documented.

If the `Metadata` is not loaded yet (`isloaded` returns `false`) then that is
done first, and the resulting documentation is returned.


*source:*
[Docile/src/interface.jl:56](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L56)

---

<a id="method__modulename.1" class="lexicon_definition"></a>
#### modulename(e::Docile.Entry{category}) [¶](#method__modulename.1)
Module where the entry is defined.


*source:*
[Docile/src/interface.jl:152](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L152)

---

<a id="method__modulename.2" class="lexicon_definition"></a>
#### modulename(meta::Docile.Metadata) [¶](#method__modulename.2)
Module where the `Metadata` object is defined.


*source:*
[Docile/src/interface.jl:76](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L76)

---

<a id="method__parsed.1" class="lexicon_definition"></a>
#### parsed(d::Docile.Docs{format}) [¶](#method__parsed.1)
The parsed documentation for an object. Lazy parsing.


*source:*
[Docile/src/interface.jl:181](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L181)

---

<a id="method__parsedocs.1" class="lexicon_definition"></a>
#### parsedocs{ext}(d::Docile.Docs{ext}) [¶](#method__parsedocs.1)
Extension method for handling arbitrary docstring formats.

Parsers for additional formats can be defined by extending this method as follows:

```julia
import Docile.Interface: parsedocs

parsedocs(d::Docs{:format}) = Format.parse(data(d))

```

where `:format` is the symbol representing the docstring's format and `Format.parse` is
the desired parser.


*source:*
[Docile/src/interface.jl:198](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L198)

---

<a id="method__root.1" class="lexicon_definition"></a>
#### root(meta::Docile.Metadata) [¶](#method__root.1)
File containing the module definition documented with the `meta` object.


*source:*
[Docile/src/interface.jl:91](https://github.com/MichaelHatherly/Docile.jl/tree/98f64bfc7f14afbd19739c66d669fbc4dfd3fdcf/src/interface.jl#L91)

