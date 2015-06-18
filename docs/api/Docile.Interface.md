# Docile.Interface


## Functions [Exported]

---

<a id="function__parsedocs.1" class="lexicon_definition"></a>
#### parsedocs [¶](#function__parsedocs.1)
Parsing hook for specifying how to parse raw docstrings into formatted text.


*source:*
[Docile/src/Interface/legacy.jl:188](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L188)

## Methods [Exported]

---

<a id="method__category.1" class="lexicon_definition"></a>
#### category{C}(::Docile.Legacy.Entry{C}) [¶](#method__category.1)
What category does an ``Entry`` object belong to?




*source:*
[Docile/src/Interface/legacy.jl:137](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L137)

---

<a id="method__data.1" class="lexicon_definition"></a>
#### data(d::Docile.Legacy.Docs{format}) [¶](#method__data.1)
Raw docstring associated with a ``Docs`` object ``d``.




*source:*
[Docile/src/Interface/legacy.jl:169](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L169)

---

<a id="method__docs.1" class="lexicon_definition"></a>
#### docs(e::Docile.Legacy.Entry{category}) [¶](#method__docs.1)
The ``Docs`` object for an ``Entry`` object ``e``.




*source:*
[Docile/src/Interface/legacy.jl:158](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L158)

---

<a id="method__documentation.1" class="lexicon_definition"></a>
#### documentation(mod::Module) [¶](#method__documentation.1)
The ``Metadata`` object associated with a module ``mod``.




*source:*
[Docile/src/Interface/legacy.jl:203](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L203)

---

<a id="method__documented.1" class="lexicon_definition"></a>
#### documented() [¶](#method__documented.1)
Returns the modules that are currently documented by Docile.


*source:*
[Docile/src/Interface/legacy.jl:26](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L26)

---

<a id="method__entries.1" class="lexicon_definition"></a>
#### entries(meta::Docile.Legacy.Metadata) [¶](#method__entries.1)
``ObjectIdDict`` containing documented objects and their associated ``Entry``s.




*source:*
[Docile/src/Interface/legacy.jl:68](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L68)

---

<a id="method__files.1" class="lexicon_definition"></a>
#### files(meta::Docile.Legacy.Metadata) [¶](#method__files.1)
List of all ``include``d files in a module documented by ``Metadata`` object ``meta``.




*source:*
[Docile/src/Interface/legacy.jl:82](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L82)

---

<a id="method__format.1" class="lexicon_definition"></a>
#### format{F}(d::Docile.Legacy.Docs{F}) [¶](#method__format.1)
The format that a docstring is written in.




*source:*
[Docile/src/Interface/legacy.jl:176](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L176)

---

<a id="method__isdocumented.1" class="lexicon_definition"></a>
#### isdocumented(mod::Module) [¶](#method__isdocumented.1)
Is the module ``mod`` documented by Docile?


*source:*
[Docile/src/Interface/legacy.jl:31](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L31)

---

<a id="method__isexported.1" class="lexicon_definition"></a>
#### isexported(modname::Module,  object) [¶](#method__isexported.1)
Is the documented object ``object`` been exported from the given module ``modname``?


*source:*
[Docile/src/Interface/legacy.jl:101](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L101)

---

<a id="method__isloaded.1" class="lexicon_definition"></a>
#### isloaded(meta::Docile.Legacy.Metadata) [¶](#method__isloaded.1)
Have the docstrings contained in a module been collected yet?




*source:*
[Docile/src/Interface/legacy.jl:89](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L89)

---

<a id="method__manual.1" class="lexicon_definition"></a>
#### manual(meta::Docile.Legacy.Metadata) [¶](#method__manual.1)
The manual files for a ``Metadata`` object ``meta``.




*source:*
[Docile/src/Interface/legacy.jl:61](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L61)

---

<a id="method__metadata.1" class="lexicon_definition"></a>
#### metadata(e::Docile.Legacy.Entry{category}) [¶](#method__metadata.1)
Arbitrary additional metadata associated with a particular ``Entry`` ``e``.




*source:*
[Docile/src/Interface/legacy.jl:151](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L151)

---

<a id="method__metadata.2" class="lexicon_definition"></a>
#### metadata(meta::Docile.Legacy.Metadata) [¶](#method__metadata.2)
The ``Dict{Symbol, Any}`` containing arbitrary additional data about a ``Metadata`` object.




*source:*
[Docile/src/Interface/legacy.jl:96](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L96)

---

<a id="method__metadata.3" class="lexicon_definition"></a>
#### metadata(mod::Module) [¶](#method__metadata.3)
Get the ``Metadata`` object associated with a module ``mod``.




*source:*
[Docile/src/Interface/legacy.jl:38](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L38)

---

<a id="method__modulename.1" class="lexicon_definition"></a>
#### modulename(e::Docile.Legacy.Entry{category}) [¶](#method__modulename.1)
Which module does the ``Entry`` object come from?




*source:*
[Docile/src/Interface/legacy.jl:144](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L144)

---

<a id="method__modulename.2" class="lexicon_definition"></a>
#### modulename(meta::Docile.Legacy.Metadata) [¶](#method__modulename.2)
The ``Module`` that a ``Metadata`` object documents.




*source:*
[Docile/src/Interface/legacy.jl:54](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L54)

---

<a id="method__parsed.1" class="lexicon_definition"></a>
#### parsed(d::Docile.Legacy.Docs{format}) [¶](#method__parsed.1)
Get the parsed docstring for a ``Docs`` object ``d``.




*source:*
[Docile/src/Interface/legacy.jl:183](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L183)

---

<a id="method__root.1" class="lexicon_definition"></a>
#### root(meta::Docile.Legacy.Metadata) [¶](#method__root.1)
The rootfile of the module documented by a ``Metadata`` object ``meta``.




*source:*
[Docile/src/Interface/legacy.jl:75](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L75)


## Functions [Internal]

---

<a id="function__name.1" class="lexicon_definition"></a>
#### name [¶](#function__name.1)
Get the ``Symbol`` representing an object such as ``Function`` or ``Method``.


*source:*
[Docile/src/Interface/legacy.jl:120](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L120)

## Globals [Internal]

---

<a id="global__documented.1" class="lexicon_definition"></a>
#### DOCUMENTED [¶](#global__documented.1)
Storage for deprecated ``Metadata`` documentation.




*source:*
[Docile/src/Interface/legacy.jl:21](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Interface/legacy.jl#L21)

