# Docile.Legacy


## Macros [Exported]

---

<a id="macro___comment.1" class="lexicon_definition"></a>
#### @comment(text) [¶](#macro___comment.1)
Deprecated macro for adding object-independent docstrings to a module.

Use the following syntax instead:

    ["..."]




*source:*
[Docile/src/Legacy/macros.jl:54](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/macros.jl#L54)

---

<a id="macro___file_str.1" class="lexicon_definition"></a>
#### @file_str(text) [¶](#macro___file_str.1)
The text found in the file ``text`` is used as the docstring content.

Deprecated in favour of automatically using a file's content if the docstring
matches a file path.




*source:*
[Docile/src/Legacy/macros.jl:66](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/macros.jl#L66)


## Methods [Internal]

---

<a id="method__call.1" class="lexicon_definition"></a>
#### call(::Type{Docile.Legacy.Manual}, ::Void, files) [¶](#method__call.1)
Usage from REPL, use current directory as root.

*source:*
[Docile/src/Legacy/types.jl:49](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/types.jl#L49)

---

<a id="method__data.1" class="lexicon_definition"></a>
#### data(n, docstr) [¶](#method__data.1)
Assign to docs to `n` and return a dictionary of keyword arguments.


*source:*
[Docile/src/Legacy/atdoc.jl:26](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/atdoc.jl#L26)

---

<a id="method__doc.1" class="lexicon_definition"></a>
#### doc(expr::Expr) [¶](#method__doc.1)
Main documentation generation routine.


*source:*
[Docile/src/Legacy/atdoc.jl:72](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/atdoc.jl#L72)

---

<a id="method__doc.2" class="lexicon_definition"></a>
#### doc(expr::Expr, generic) [¶](#method__doc.2)
Main documentation generation routine.


*source:*
[Docile/src/Legacy/atdoc.jl:72](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/atdoc.jl#L72)

---

<a id="method__doc.3" class="lexicon_definition"></a>
#### doc(s::Symbol, ex::Expr) [¶](#method__doc.3)
Detect '@doc+' syntax in macro call.


*source:*
[Docile/src/Legacy/atdoc.jl:200](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/atdoc.jl#L200)

---

<a id="method__lateguess.1" class="lexicon_definition"></a>
#### lateguess(::Function) [¶](#method__lateguess.1)
Return the category of an object.


*source:*
[Docile/src/Legacy/atdoc.jl:65](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/atdoc.jl#L65)

---

<a id="method__nameof.1" class="lexicon_definition"></a>
#### nameof(x::Expr) [¶](#method__nameof.1)
Get the symbolic name of an expression.


*source:*
[Docile/src/Legacy/atdoc.jl:40](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/atdoc.jl#L40)

---

<a id="method__unarrow.1" class="lexicon_definition"></a>
#### unarrow(x::Expr) [¶](#method__unarrow.1)
Extract the docstring and expression to be documented from an `->` expression.


*source:*
[Docile/src/Legacy/atdoc.jl:58](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/atdoc.jl#L58)

---

<a id="method__unblock.1" class="lexicon_definition"></a>
#### unblock(x::Expr) [¶](#method__unblock.1)
Extract the line number and documented object expression from a block.


*source:*
[Docile/src/Legacy/atdoc.jl:51](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/atdoc.jl#L51)

## Macros [Internal]

---

<a id="macro___doc.1" class="lexicon_definition"></a>
#### @doc(ex) [¶](#macro___doc.1)
Document an object.

    @doc " ... " ->
    f(x) = x

    @doc+ " ... " ->
    g(x) = x



*source:*
[Docile/src/Legacy/atdoc.jl:216](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/atdoc.jl#L216)

---

<a id="macro___init.1" class="lexicon_definition"></a>
#### @init() [¶](#macro___init.1)
Setup macro-style documentation datastructures.


*source:*
[Docile/src/Legacy/atdoc.jl:5](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Legacy/atdoc.jl#L5)

