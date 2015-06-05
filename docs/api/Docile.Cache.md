# Docile.Cache


## Methods [Exported]

---

<a id="method__clear.1" class="lexicon_definition"></a>
#### clear!() [¶](#method__clear.1)
Empty the documentation cache of all data.


*source:*
[Docile/src/Cache/interface.jl:49](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L49)

---

<a id="method__getmeta.1" class="lexicon_definition"></a>
#### getmeta(m::Module) [¶](#method__getmeta.1)
Get the metadata dictionaries for all documented objects in a module.


*source:*
[Docile/src/Cache/interface.jl:29](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L29)

---

<a id="method__getmeta.2" class="lexicon_definition"></a>
#### getmeta(m::Module,  obj) [¶](#method__getmeta.2)
Get the ``Dict{Symbol, Any}`` containing an object's metadata.


*source:*
[Docile/src/Cache/interface.jl:34](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L34)

---

<a id="method__getparsed.1" class="lexicon_definition"></a>
#### getparsed(m::Module) [¶](#method__getparsed.1)
Get the parsed docstrings associated with all documented objects in a module.


*source:*
[Docile/src/Cache/interface.jl:16](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L16)

---

<a id="method__getparsed.2" class="lexicon_definition"></a>
#### getparsed(m::Module,  obj) [¶](#method__getparsed.2)
Get the parsed form of a docstring associated with an object ``obj``.

Automatically parses the raw docstring on demand when first called.
Subsequent calls will return the parsed docstring that has been cached.


*source:*
[Docile/src/Cache/interface.jl:24](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L24)

---

<a id="method__getraw.1" class="lexicon_definition"></a>
#### getraw(m::Module) [¶](#method__getraw.1)
Get the raw docstrings associated with all documented objects in a module.


*source:*
[Docile/src/Cache/interface.jl:6](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L6)

---

<a id="method__getraw.2" class="lexicon_definition"></a>
#### getraw(m::Module,  obj) [¶](#method__getraw.2)
Get the raw docstring associated with a documented object ``obj`` in module ``m``.


*source:*
[Docile/src/Cache/interface.jl:11](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L11)

---

<a id="method__objects.1" class="lexicon_definition"></a>
#### objects(m::Module) [¶](#method__objects.1)
Return all documented objects found in a module ``m``.


*source:*
[Docile/src/Cache/interface.jl:54](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L54)


## Methods [Internal]

---

<a id="method__extractor.1" class="lexicon_definition"></a>
#### extractor!(cache::Docile.Cache.GlobalCache,  raw::AbstractString,  m::Module,  obj) [¶](#method__extractor.1)
Extract metadata embedded in docstrings and run the `parsedocs` method defined
for the docstring `raw`.


*source:*
[Docile/src/Cache/utilities.jl:43](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/utilities.jl#L43)

---

<a id="method__findmeta.1" class="lexicon_definition"></a>
#### findmeta(m::Module,  obj,  key::Symbol,  T) [¶](#method__findmeta.1)
Find the metadata for ``key`` associated with an object ``obj`` in module ``m``.

Returns a ``Nullable{T}`` object. ``isnull`` must be called to determine whether
an object was actually found or not.

When ``obj`` does not contain the field ``field`` then the module's metadata
and all it's parents are searched in turn. Finally the package's metadata is
searched for ``field``.


*source:*
[Docile/src/Cache/interface.jl:71](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L71)

---

<a id="method__getmodule.1" class="lexicon_definition"></a>
#### getmodule(m::Module) [¶](#method__getmodule.1)
Get the ``ModuleData`` object associated with a module ``m``.


*source:*
[Docile/src/Cache/interface.jl:44](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L44)

---

<a id="method__getpackage.1" class="lexicon_definition"></a>
#### getpackage(m::Module) [¶](#method__getpackage.1)
Get the ``PackageData`` object associated with a module ``m``.


*source:*
[Docile/src/Cache/interface.jl:39](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L39)

---

<a id="method__loadedmodules.1" class="lexicon_definition"></a>
#### loadedmodules() [¶](#method__loadedmodules.1)
Returns the set of all loaded modules.


*source:*
[Docile/src/Cache/interface.jl:76](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L76)

---

<a id="method__parse.1" class="lexicon_definition"></a>
#### parse!(cache::Docile.Cache.GlobalCache,  m::Module) [¶](#method__parse.1)
Parse raw docstrings in module `m` into their parsed form.

Also extracts additional embedded metadata found in each raw docstring.


*source:*
[Docile/src/Cache/utilities.jl:30](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/utilities.jl#L30)

---

<a id="method__togglebase.1" class="lexicon_definition"></a>
#### togglebase() [¶](#method__togglebase.1)
Turn on documenting of ``Base`` and it's submodules. Off by default.


*source:*
[Docile/src/Cache/interface.jl:59](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/interface.jl#L59)

## Types [Internal]

---

<a id="type__docscache.1" class="lexicon_definition"></a>
#### Docile.Cache.DocsCache [¶](#type__docscache.1)
For a single module store raw docstrings, parsed docs, and metadata.


*source:*
[Docile/src/Cache/types.jl:6](https://github.com/MichaelHatherly/Docile.jl/tree/950375199c1c691902d2b2254a33d92fc7f2b552/src/Cache/types.jl#L6)

