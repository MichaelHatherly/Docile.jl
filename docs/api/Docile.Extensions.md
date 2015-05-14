# Docile.Extensions


## Modules [Exported]

---

<a id="module__extensions.1" class="lexicon_definition"></a>
#### Docile.Extensions [¶](#module__extensions.1)
Methods to extend how Docile handles parsing of docstrings.

These methods could just as easily be defined outside of the package and allow
for package authors to customise how their documentation is presented to users.


*source:*
[Docile/src/Extensions/Extensions.jl:11](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Extensions/Extensions.jl#L11)


## Methods [Internal]

---

<a id="method__metamacro.1" class="lexicon_definition"></a>
#### metamacro(::Docile.Formats.MetaMacro{:get}, body, mod, obj) [¶](#method__metamacro.1)
Get the value stored in an object's metadata field.

In the following example the value associated with the field ``:author`` is
spliced back into the docstring in place of it:

    !!get(author)

When no field is found in the metadata for the object, the module and package
metadata are searched in turn.


*source:*
[Docile/src/Extensions/Extensions.jl:27](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Extensions/Extensions.jl#L27)

---

<a id="method__metamacro.2" class="lexicon_definition"></a>
#### metamacro(::Docile.Formats.MetaMacro{:include}, body, mod, obj) [¶](#method__metamacro.2)
Splice the contents of a file in place of the ``metamacro`` call.

    !!include(filename)

``filename`` must reference an available file found relative to the source file
where the ``metamacro`` is called from.


*source:*
[Docile/src/Extensions/Extensions.jl:93](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Extensions/Extensions.jl#L93)

---

<a id="method__metamacro.3" class="lexicon_definition"></a>
#### metamacro(::Docile.Formats.MetaMacro{:longform}, body, mod, obj) [¶](#method__metamacro.3)
Make the contained text only appear in non-interactive output.

    !!longform(
    ...
    )

In the REPL the text is not displayed. Other ``metamacro`` calls can be nested
inside a ``!!longform(...)`` call, such as ``!!include(...)``.


*source:*
[Docile/src/Extensions/Extensions.jl:79](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Extensions/Extensions.jl#L79)

---

<a id="method__metamacro.4" class="lexicon_definition"></a>
#### metamacro(::Docile.Formats.MetaMacro{:setget}, body, mod, obj) [¶](#method__metamacro.4)
Equivalent to ``!!set`` followed by ``!!get`` for the provided key.

    !!setget(author:Author's Name)

The key in this example is ``:author`` and the value is ``"Author's Name"``.


*source:*
[Docile/src/Extensions/Extensions.jl:49](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Extensions/Extensions.jl#L49)

---

<a id="method__metamacro.5" class="lexicon_definition"></a>
#### metamacro(::Docile.Formats.MetaMacro{:set}, body, mod, obj) [¶](#method__metamacro.5)
Set the value for a field in an object's metadata.

    !!set(author:Author's Name)

The key in this example is ``:author`` and the value is ``"Author's Name"``.


*source:*
[Docile/src/Extensions/Extensions.jl:36](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Extensions/Extensions.jl#L36)

---

<a id="method__metamacro.6" class="lexicon_definition"></a>
#### metamacro(::Docile.Formats.MetaMacro{:summary}, body, mod, obj) [¶](#method__metamacro.6)
Specify a short (120 character) summary for a docstring.

    !!summary(...)

The text will be used in the generated index page produced by Lexicon.

A warning is printed when a summary exceeds the character limit.


*source:*
[Docile/src/Extensions/Extensions.jl:63](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Extensions/Extensions.jl#L63)

