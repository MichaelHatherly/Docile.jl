# Docile.Cache


## Methods [Exported]

---

<a id="method__clear.1" class="lexicon_definition"></a>
#### clear!() [¶](#method__clear.1)
Remove all cached objects, modules and packages from storage.


*source:*
[Docile/src/Cache/storage.jl:217](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L217)

---

<a id="method__getmeta.1" class="lexicon_definition"></a>
#### getmeta(m::Module) [¶](#method__getmeta.1)
Return a reference to the metadata cache for a given module `m`.


*source:*
[Docile/src/Cache/storage.jl:201](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L201)

---

<a id="method__getmeta.2" class="lexicon_definition"></a>
#### getmeta(m::Module, obj) [¶](#method__getmeta.2)
Return the metadata `Dict` for a given object `obj` found in module `m`.


*source:*
[Docile/src/Cache/storage.jl:206](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L206)

---

<a id="method__getparsed.1" class="lexicon_definition"></a>
#### getparsed(m::Module) [¶](#method__getparsed.1)
Return a reference to the parsed docstring cache for a given module `m`.


*source:*
[Docile/src/Cache/storage.jl:182](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L182)

---

<a id="method__getparsed.2" class="lexicon_definition"></a>
#### getparsed(m::Module, obj) [¶](#method__getparsed.2)
Return the parsed form of a docstring for object `obj` in module `m`.

When the parsed docstring has never been accessed before, it is parsed using the
user-definable `Docile.Formats.parsedocs` method.


*source:*
[Docile/src/Cache/storage.jl:190](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L190)

---

<a id="method__getraw.1" class="lexicon_definition"></a>
#### getraw(m::Module) [¶](#method__getraw.1)
Return a reference to the raw docstring storage for a given module `m`.


*source:*
[Docile/src/Cache/storage.jl:166](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L166)

---

<a id="method__getraw.2" class="lexicon_definition"></a>
#### getraw(m::Module, obj) [¶](#method__getraw.2)
Return the raw docstring for a given `obj` in the module `m`.


*source:*
[Docile/src/Cache/storage.jl:171](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L171)

---

<a id="method__objects.1" class="lexicon_definition"></a>
#### objects(m::Module) [¶](#method__objects.1)
List of all documented objects in a module `m`.


*source:*
[Docile/src/Cache/storage.jl:222](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L222)


## Methods [Internal]

---

<a id="method__cleardocs.1" class="lexicon_definition"></a>
#### cleardocs!() [¶](#method__cleardocs.1)
Empty cached docstrings, parsed docs, and metadata from all modules.


*source:*
[Docile/src/Cache/storage.jl:158](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L158)

---

<a id="method__clearpackages.1" class="lexicon_definition"></a>
#### clearpackages!() [¶](#method__clearpackages.1)
Empty all loaded packages and modules from cache.


*source:*
[Docile/src/Cache/storage.jl:103](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L103)

---

<a id="method__extractor.1" class="lexicon_definition"></a>
#### extractor!(raw::AbstractString, m::Module, obj) [¶](#method__extractor.1)
Extract metadata embedded in docstrings and run the `parsedocs` method defined
for the docstring `raw`.


*source:*
[Docile/src/Cache/utilities.jl:50](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/utilities.jl#L50)

---

<a id="method__getdocs.1" class="lexicon_definition"></a>
#### getdocs(m::Module) [¶](#method__getdocs.1)
Return documentation cache of a module `m`. Initialise an empty cache if needed.


*source:*
[Docile/src/Cache/storage.jl:150](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L150)

---

<a id="method__getmodule.1" class="lexicon_definition"></a>
#### getmodule(m::Module) [¶](#method__getmodule.1)
Get the `ModuleData` object associated with a module `m`.


*source:*
[Docile/src/Cache/storage.jl:63](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L63)

---

<a id="method__getpackage.1" class="lexicon_definition"></a>
#### getpackage(m::Module) [¶](#method__getpackage.1)
Return the `PackageData` object that represents a registered package.


*source:*
[Docile/src/Cache/storage.jl:83](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L83)

---

<a id="method__hasdocs.1" class="lexicon_definition"></a>
#### hasdocs(m::Module) [¶](#method__hasdocs.1)
Has module `m` had documentation extracted with `Docile.Collector.docstrings`?


*source:*
[Docile/src/Cache/storage.jl:145](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L145)

---

<a id="method__hasmodule.1" class="lexicon_definition"></a>
#### hasmodule(m::Module) [¶](#method__hasmodule.1)
Has the module `m` been registered with Docile.

When module isn't found then check for newly added packages first.


*source:*
[Docile/src/Cache/storage.jl:58](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L58)

---

<a id="method__haspackage.1" class="lexicon_definition"></a>
#### haspackage(m::Module) [¶](#method__haspackage.1)
Has the package with root module `m` been registered with Docile?

When package isn't found then check for newly added packages first.


*source:*
[Docile/src/Cache/storage.jl:78](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L78)

---

<a id="method__hasparsed.1" class="lexicon_definition"></a>
#### hasparsed(m::Module) [¶](#method__hasparsed.1)
Has module `m` been parsed yet?


*source:*
[Docile/src/Cache/storage.jl:112](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L112)

---

<a id="method__modules.1" class="lexicon_definition"></a>
#### modules() [¶](#method__modules.1)
List of all documented modules currently stored by Docile.


*source:*
[Docile/src/Cache/storage.jl:140](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L140)

---

<a id="method__parse.1" class="lexicon_definition"></a>
#### parse!(m::Module) [¶](#method__parse.1)
Parse raw docstrings in module `m` into their parsed form.

Also extracts additional embedded metadata found in each raw docstring.


*source:*
[Docile/src/Cache/utilities.jl:37](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/utilities.jl#L37)

---

<a id="method__setparsed.1" class="lexicon_definition"></a>
#### setparsed(m::Module) [¶](#method__setparsed.1)
Module `m` has had it's docstrings parsed.


*source:*
[Docile/src/Cache/storage.jl:117](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L117)

---

<a id="method__togglebase.1" class="lexicon_definition"></a>
#### togglebase() [¶](#method__togglebase.1)
Switch on/off documenting of ``Base`` and it's submodules.

**Note:** This is an experimental feature and so is initially disabled.


*source:*
[Docile/src/Cache/storage.jl:23](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L23)

## Macros [Internal]

---

<a id="macro____.1" class="lexicon_definition"></a>
#### @+expr [¶](#macro____.1)
Macro to make a function definition global. Used in `let`-blocks.


*source:*
[Docile/src/Cache/storage.jl:6](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Cache/storage.jl#L6)

## Comments [Internal]

---

<a id="comment__comment.1" class="lexicon_definition"></a>
#### Docile.Legacy.Comment(symbol("##comment#3505")) [¶](#comment__comment.1)
Caching of docstrings and package metadata.

---

<a id="comment__comment.2" class="lexicon_definition"></a>
#### Docile.Legacy.Comment(symbol("##comment#3506")) [¶](#comment__comment.2)
Helper functions related to documentation and package metadata caching.

---

<a id="comment__comment.3" class="lexicon_definition"></a>
#### Docile.Legacy.Comment(symbol("##comment#3507")) [¶](#comment__comment.3)
Global documentation caches and their associated getters and setters.

