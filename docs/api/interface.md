# Docile.Interface
Utility methods for working with `Entry` and `Metadata` types from the `Docile`
module (documentation available [here](api/docile)).


## Exported
---

#### category{C}(e::Entry{C})
Symbol representing the category that an `Entry` belongs to.


**source:**
[Docile/src/interface.jl:146](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L146)

---

#### data(d::Docs{format})
The raw content stored in a docstring.


**source:**
[Docile/src/interface.jl:170](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L170)

---

#### docs(e::Entry{category})
Documentation related to the entry.


**source:**
[Docile/src/interface.jl:161](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L161)

---

#### documented()
Returns the modules that are currently documented by Docile.


**source:**
[Docile/src/interface.jl:41](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L41)

---

#### entries(meta::Metadata)
Dictionary associating objects and documentation entries.


**source:**
[Docile/src/interface.jl:86](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L86)

---

#### files(meta::Metadata)
All files `include`d in the module documented with the `meta` object.


**source:**
[Docile/src/interface.jl:96](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L96)

---

#### format{F}(d::Docs{F})
Return the format that a docstring is written in.


**source:**
[Docile/src/interface.jl:175](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L175)

---

#### isdocumented(mod::Module)
Is the given module `modname` documented using Docile?


**source:**
[Docile/src/interface.jl:46](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L46)

---

#### isexported(modname::Module, comment::Comment)
Check whether `object` has been exported from a *documented* module `modname`.


**source:**
[Docile/src/interface.jl:111](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L111)

---

#### isloaded(meta::Metadata)
Has the documentation contained in a module been loaded into the `meta` object?


**source:**
[Docile/src/interface.jl:101](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L101)

---

#### manual(meta::Metadata)
The `Manual` object containing a module's manual pages.


**source:**
[Docile/src/interface.jl:81](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L81)

---

#### metadata(e::Entry{category})
Dictionary containing arbitrary metadata related to an entry.


**source:**
[Docile/src/interface.jl:156](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L156)

---

#### metadata(meta::Metadata)
A dictionary containing configuration settings related to the `meta` object.


**source:**
[Docile/src/interface.jl:106](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L106)

---

#### metadata(mod::Module)
Returns the `Metadata` object stored in a module `modname` by Docile.

Throws an `ArgumentError` when the module has not been documented.

If the `Metadata` is not loaded yet (`isloaded` returns `false`) then that is
done first, and the resulting documentation is returned.


**source:**
[Docile/src/interface.jl:56](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L56)

---

#### modulename(e::Entry{category})
Module where the entry is defined.


**source:**
[Docile/src/interface.jl:151](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L151)

---

#### modulename(meta::Metadata)
Module where the `Metadata` object is defined.


**source:**
[Docile/src/interface.jl:76](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L76)

---

#### parsed(d::Docs{format})
The parsed documentation for an object. Lazy parsing.


**source:**
[Docile/src/interface.jl:180](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L180)

---

#### parsedocs(d::Docs{:txt})
Extension method for handling arbitrary docstring formats.

Parsers for additional formats can be defined by extending this method as follows:

```julia
import Docile.Interface: parsedocs

parsedocs(d::Docs{:format}) = Format.parse(data(d))

```

where `:format` is the symbol representing the docstring's format and `Format.parse` is
the desired parser.


**source:**
[Docile/src/interface.jl:197](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L197)

---

#### root(meta::Metadata)
File containing the module definition documented with the `meta` object.


**source:**
[Docile/src/interface.jl:91](https://github.com/MichaelHatherly/Docile.jl/tree/69fd474f97eff0746cc8ae1c4f51551ecc9320cb/src/interface.jl#L91)


