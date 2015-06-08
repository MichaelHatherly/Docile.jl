# Docile.Utilities


## Methods [Exported]

---

<a id="method__parsefile.1" class="lexicon_definition"></a>
#### parsefile(file::AbstractString) [¶](#method__parsefile.1)
Retrieve the ``Expr`` object from a Julia source file ``file``.

Caches the expression based on it's file name and ``mtime`` value.


*source:*
[Docile/src/Utilities.jl:57](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L57)


## Methods [Internal]

---

<a id="method____init_cache__.1" class="lexicon_definition"></a>
#### __init_cache__() [¶](#method____init_cache__.1)
Check cache directory for up to date version directory. Remove older version
directories if any are found. Should be called on module initialisation.


*source:*
[Docile/src/Utilities.jl:30](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L30)

---

<a id="method____init_cache__.2" class="lexicon_definition"></a>
#### __init_cache__(cache) [¶](#method____init_cache__.2)
Check cache directory for up to date version directory. Remove older version
directories if any are found. Should be called on module initialisation.


*source:*
[Docile/src/Utilities.jl:30](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L30)

---

<a id="method____init_cache__.3" class="lexicon_definition"></a>
#### __init_cache__(cache,  current) [¶](#method____init_cache__.3)
Check cache directory for up to date version directory. Remove older version
directories if any are found. Should be called on module initialisation.


*source:*
[Docile/src/Utilities.jl:30](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L30)

---

<a id="method__expandpath.1" class="lexicon_definition"></a>
#### expandpath(path) [¶](#method__expandpath.1)
Convert a path to absolute. Relative paths are guessed to be from Julia ``/base``.


*source:*
[Docile/src/Utilities.jl:107](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L107)

---

<a id="method__message.1" class="lexicon_definition"></a>
#### message(msg::AbstractString) [¶](#method__message.1)
Print a 'Docile'-formatted message to ``STDOUT``.


*source:*
[Docile/src/Utilities.jl:87](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L87)

---

<a id="method__path_id.1" class="lexicon_definition"></a>
#### path_id(file::AbstractString) [¶](#method__path_id.1)
Returns the cache path for a given file ``file``.


*source:*
[Docile/src/Utilities.jl:46](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L46)

---

<a id="method__samemodule.1" class="lexicon_definition"></a>
#### samemodule(mod,  def::Method) [¶](#method__samemodule.1)
Is the module where a function/method is defined the same as ``mod``?


*source:*
[Docile/src/Utilities.jl:92](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L92)

## Globals [Internal]

---

<a id="global__base.1" class="lexicon_definition"></a>
#### BASE [¶](#global__base.1)
Path to Julia's base source code.


*source:*
[Docile/src/Utilities.jl:102](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L102)

---

<a id="global__cache_cur.1" class="lexicon_definition"></a>
#### CACHE_CUR [¶](#global__cache_cur.1)
The current versioned cache subdirectory set by ``CACHE_VER``

*source:*
[Docile/src/Utilities.jl:24](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L24)

---

<a id="global__cache_dir.1" class="lexicon_definition"></a>
#### CACHE_DIR [¶](#global__cache_dir.1)
Path to Docile's main cache folder.

*source:*
[Docile/src/Utilities.jl:21](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L21)

---

<a id="global__cache_ver.1" class="lexicon_definition"></a>
#### CACHE_VER [¶](#global__cache_ver.1)
Internal version of the cache structure.

*source:*
[Docile/src/Utilities.jl:18](https://github.com/MichaelHatherly/Docile.jl/tree/af11a47f0b15300bf69117c6e0bdcfe966f53056/src/Utilities.jl#L18)

