# Docile.Interface
Utility methods for working with `Entry` and `Metadata` types from the `Docile`
module (documentation available [here](api/Docile)).


## Exported
---

### category{C}(e::Docile.Entry{C})
Symbol representing the category that an `Entry` belongs to.


*source:*
[Docile/src/interface.jl:147](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L147)

---

### data(d::Docile.Docs{format})
The raw content stored in a docstring.


*source:*
[Docile/src/interface.jl:171](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L171)

---

### docs(e::Docile.Entry{category})
Documentation related to the entry.


*source:*
[Docile/src/interface.jl:162](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L162)

---

### documented()
Returns the modules that are currently documented by Docile.


*source:*
[Docile/src/interface.jl:41](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L41)

---

### entries(meta::Docile.Metadata)
Dictionary associating objects and documentation entries.


*source:*
[Docile/src/interface.jl:86](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L86)

---

### files(meta::Docile.Metadata)
All files `include`d in the module documented with the `meta` object.


*source:*
[Docile/src/interface.jl:96](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L96)

---

### format{F}(d::Docile.Docs{F})
Return the format that a docstring is written in.


*source:*
[Docile/src/interface.jl:176](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L176)

---

### isdocumented(mod::Module)
Is the given module `modname` documented using Docile?


*source:*
[Docile/src/interface.jl:46](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L46)

---

### isexported(modname::Module, object)
Check whether `object` has been exported from a *documented* module `modname`.


*source:*
[Docile/src/interface.jl:111](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L111)

---

### isloaded(meta::Docile.Metadata)
Has the documentation contained in a module been loaded into the `meta` object?


*source:*
[Docile/src/interface.jl:101](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L101)

---

### manual(meta::Docile.Metadata)
The `Manual` object containing a module's manual pages.


*source:*
[Docile/src/interface.jl:81](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L81)

---

### metadata(e::Docile.Entry{category})
Dictionary containing arbitrary metadata related to an entry.


*source:*
[Docile/src/interface.jl:157](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L157)

---

### metadata(meta::Docile.Metadata)
A dictionary containing configuration settings related to the `meta` object.


*source:*
[Docile/src/interface.jl:106](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L106)

---

### metadata(mod::Module)
Returns the `Metadata` object stored in a module `modname` by Docile.

Throws an `ArgumentError` when the module has not been documented.

If the `Metadata` is not loaded yet (`isloaded` returns `false`) then that is
done first, and the resulting documentation is returned.


*source:*
[Docile/src/interface.jl:56](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L56)

---

### modulename(e::Docile.Entry{category})
Module where the entry is defined.


*source:*
[Docile/src/interface.jl:152](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L152)

---

### modulename(meta::Docile.Metadata)
Module where the `Metadata` object is defined.


*source:*
[Docile/src/interface.jl:76](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L76)

---

### parsed(d::Docile.Docs{format})
The parsed documentation for an object. Lazy parsing.


*source:*
[Docile/src/interface.jl:181](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L181)

---

### parsedocs{ext}(d::Docile.Docs{ext})
Extension method for handling arbitrary docstring formats.

Parsers for additional formats can be defined by extending this method as follows:

```julia
import Docile.Interface: parsedocs

parsedocs(d::Docs{:format}) = Format.parse(data(d))

```

where `:format` is the symbol representing the docstring's format and `Format.parse` is
the desired parser.


*source:*
[Docile/src/interface.jl:198](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L198)

---

### root(meta::Docile.Metadata)
File containing the module definition documented with the `meta` object.


*source:*
[Docile/src/interface.jl:91](https://github.com/MichaelHatherly/Docile.jl/tree/6c6b9e9701d11bd104d638f9c7e612961160be3c/src/interface.jl#L91)

