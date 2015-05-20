# Docile.Collector


## Functions [Internal]

---

<a id="function__isdocstring.1" class="lexicon_definition"></a>
#### isdocstring [¶](#function__isdocstring.1)
Does the expression represent a docstring?

*source:*
[Docile/src/Collector/utilities.jl:152](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L152)

---

<a id="function__name.1" class="lexicon_definition"></a>
#### name [¶](#function__name.1)
Extract the symbol identifying an expression.

*source:*
[Docile/src/Collector/utilities.jl:288](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L288)

---

<a id="function__process.1" class="lexicon_definition"></a>
#### process! [¶](#function__process.1)
Extract all docstrings and metadata from a given file

*source:*
[Docile/src/Collector/docstrings.jl:38](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/docstrings.jl#L38)

---

<a id="function__recheck.1" class="lexicon_definition"></a>
#### recheck [¶](#function__recheck.1)
Convert category from `:symbol` to either `:module` or `:function`.

*source:*
[Docile/src/Collector/utilities.jl:98](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L98)

## Methods [Internal]

---

<a id="method__definedmodules.1" class="lexicon_definition"></a>
#### definedmodules!(out, expr::Expr) [¶](#method__definedmodules.1)
Return the set of toplevel modules that are defined in an expression.


*source:*
[Docile/src/Collector/utilities.jl:261](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L261)

---

<a id="method__docstrings.1" class="lexicon_definition"></a>
#### docstrings(m::Docile.Collector.ModuleData) [¶](#method__docstrings.1)
Extract all docstrings and basic metadata (file, line, & code) from a module.


*source:*
[Docile/src/Collector/docstrings.jl:16](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/docstrings.jl#L16)

---

<a id="method__findexternal.1" class="lexicon_definition"></a>
#### findexternal(docs) [¶](#method__findexternal.1)
Check whether a docstring is acutally a file path. Read that instead if it is.


*source:*
[Docile/src/Collector/utilities.jl:217](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L217)

---

<a id="method__findmodule.1" class="lexicon_definition"></a>
#### findmodule(expr::Expr, mod::Module) [¶](#method__findmodule.1)
Extract the module expression corresponding to a `Module` object.


*source:*
[Docile/src/Collector/utilities.jl:223](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L223)

---

<a id="method__findpackages.1" class="lexicon_definition"></a>
#### findpackages(rootfiles::Set{UTF8String}) [¶](#method__findpackages.1)
Return the `PackageData` objects associated with a set of files.


*source:*
[Docile/src/Collector/utilities.jl:240](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L240)

---

<a id="method__get_aside.1" class="lexicon_definition"></a>
#### get_aside!(output, moddata, state, file, block) [¶](#method__get_aside.1)
Extract the comment block from expressions and capture metadata.


*source:*
[Docile/src/Collector/docstrings.jl:75](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/docstrings.jl#L75)

---

<a id="method__get_docs.1" class="lexicon_definition"></a>
#### get_docs!(output, moduledata, state, file, block) [¶](#method__get_docs.1)
Extract a docstring and associated object(s) as well as metadata.


*source:*
[Docile/src/Collector/docstrings.jl:92](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/docstrings.jl#L92)

---

<a id="method__getcategory.1" class="lexicon_definition"></a>
#### getcategory(x) [¶](#method__getcategory.1)
The category of an expression. `:symbol` is resolved at a later stage by `recheck`.


*source:*
[Docile/src/Collector/utilities.jl:109](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L109)

---

<a id="method__getdotfile.1" class="lexicon_definition"></a>
#### getdotfile(dir::AbstractString) [¶](#method__getdotfile.1)
Check for a `.docile` configuration file in the directory `dir`.

Load the file if it is found. The file should end with a `Dict{Symbol, Any}`
and can contain any additional Julia code such as method extensions for
the `metamacro` function and custom docstring formatters.

    import Docile: Formats

    immutable MyCustomFormatter <: Formats.AbstractFormatter end

    Formats.parsedocs(::Formats.Format, raw, mod, obj) = # ...

    function Formats.metamacro(::Formats.MetaMacro{:custom}, body, mod, obj)
        # ...
    end

    # Provide additional metadata to package and its modules. Must be last in file.
    Dict(
        :format => MyCustomFormatter,
        # ...
    )


*source:*
[Docile/src/Collector/utilities.jl:323](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L323)

---

<a id="method__getobject.1" class="lexicon_definition"></a>
#### getobject(::Docile.Utilities.Head{:macro}, moduledata, state, expr, ::Any) [¶](#method__getobject.1)
Get the `(anonymous function)` object defined by a macro expression.

Used to associate docstrings with macros

    " ... "
    macro mac(args...)

    end



*source:*
[Docile/src/Collector/utilities.jl:45](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L45)

---

<a id="method__getobject.2" class="lexicon_definition"></a>
#### getobject(::Docile.Utilities.Head{:method}, moduledata, state, expr, codesource) [¶](#method__getobject.2)
Find all `Method` objects defined by a given expression.

Used to associate a docstring with one or more methods or inner constructors of
a type.

    " ... "
    f(x, y = 1) = x + y

    type T
        x :: Int
        " ... "
        T(x, y) = new(x + y)
    end



*source:*
[Docile/src/Collector/utilities.jl:25](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L25)

---

<a id="method__getobject.3" class="lexicon_definition"></a>
#### getobject(::Docile.Utilities.Head{:tuple}, ::Any, state, expr, ::Any) [¶](#method__getobject.3)
Find group of methods that match a provided signature.

Syntax example

    " ... "
    (a, Any, Vararg{Int})

defines a docstring `" ... "` for all `Method` objects of `Function` `a`
that match the signature `(Any, Int...)`.

If `a` is not yet defined at the point where the docstring is placed, then quote
the function name as follows:

    " ... "
    (:a, Any, Vararg{Int})



*source:*
[Docile/src/Collector/utilities.jl:66](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L66)

---

<a id="method__getobject.4" class="lexicon_definition"></a>
#### getobject(::Union(Docile.Utilities.Head{:vect}, Docile.Utilities.Head{:vcat}), ::Any, state, expr, ::Any) [¶](#method__getobject.4)
Find a set of methods and a set of functions that match the provided vector.

Syntax example

    " ... "
    [a, :b, (d, Any, Int)]

will associate the docstring `" ... "` with the functions `a` and `b` as well as
all methods of function `d` matching the signature `(Any, Int)`.

This syntax is a generalisation of the single symbol syntax

    " ... "
    a

or

    " ... "
    :b

and the method syntax using a tuple

    " ... "
    (d, Any, Int)



*source:*
[Docile/src/Collector/utilities.jl:95](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L95)

---

<a id="method__getobject.5" class="lexicon_definition"></a>
#### getobject(cat::Symbol, moduledata, state, expr, codesource) [¶](#method__getobject.5)
Find all objects described by an expression.


*source:*
[Docile/src/Collector/utilities.jl:6](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L6)

---

<a id="method__includedfiles.1" class="lexicon_definition"></a>
#### includedfiles(mod::Module, candidates::Set{T}) [¶](#method__includedfiles.1)
Which source files are known to be included in a module.

**Note:** files with only constants will not be detected.


*source:*
[Docile/src/Collector/search.jl:25](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/search.jl#L25)

---

<a id="method__is_aside.1" class="lexicon_definition"></a>
#### is_aside(block) [¶](#method__is_aside.1)
Is the tuple a valid comment block?


*source:*
[Docile/src/Collector/utilities.jl:175](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L175)

---

<a id="method__isdocblock.1" class="lexicon_definition"></a>
#### isdocblock(block) [¶](#method__isdocblock.1)
Does the tuple of expressions represent a valid docstring and associated object?


*source:*
[Docile/src/Collector/utilities.jl:166](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L166)

---

<a id="method__isrootfile.1" class="lexicon_definition"></a>
#### isrootfile(mod::Symbol, parsed::Expr) [¶](#method__isrootfile.1)
Is the file the root for a module `mod`. Check for `Expr(:module, ...)`.

**Note:** Assumes that all submodules have unique names.


*source:*
[Docile/src/Collector/search.jl:60](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/search.jl#L60)

---

<a id="method__isrootmodule.1" class="lexicon_definition"></a>
#### isrootmodule(m::Module) [¶](#method__isrootmodule.1)
Is the module a toplevel one not including the module `Main`?


*source:*
[Docile/src/Collector/utilities.jl:279](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L279)

---

<a id="method__location.1" class="lexicon_definition"></a>
#### location(object::Method) [¶](#method__location.1)
Path to definition of a julia object, only methods are searched for.


*source:*
[Docile/src/Collector/search.jl:51](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/search.jl#L51)

---

<a id="method__postprocess.1" class="lexicon_definition"></a>
#### postprocess!(cat::Symbol, metadata, ex) [¶](#method__postprocess.1)
Add some additional metadata for macros and method definitions.


*source:*
[Docile/src/Collector/docstrings.jl:121](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/docstrings.jl#L121)

---

<a id="method__samemodule.1" class="lexicon_definition"></a>
#### samemodule(expr, mod) [¶](#method__samemodule.1)
Does the expression `expr` represent the module name `mod`?


*source:*
[Docile/src/Collector/utilities.jl:285](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L285)

---

<a id="method__skipexpr.1" class="lexicon_definition"></a>
#### skipexpr(x) [¶](#method__skipexpr.1)
Blacklist some expressions so search doesn't decend into them.


*source:*
[Docile/src/Collector/utilities.jl:125](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/utilities.jl#L125)

---

<a id="method__store.1" class="lexicon_definition"></a>
#### store!(output, object, docs, metadata) [¶](#method__store.1)
Save docstrings and metadata for the objects that have been found.


*source:*
[Docile/src/Collector/docstrings.jl:138](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/docstrings.jl#L138)

---

<a id="method__submodules.1" class="lexicon_definition"></a>
#### submodules(mod::Module) [¶](#method__submodules.1)
Return the set of all submodules of a given module `mod`.


*source:*
[Docile/src/Collector/search.jl:6](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/search.jl#L6)

## Types [Internal]

---

<a id="type__output.1" class="lexicon_definition"></a>
#### Docile.Collector.Output [¶](#type__output.1)
Temporary container used for docstring processing. Not the final storage.


*source:*
[Docile/src/Collector/docstrings.jl:6](https://github.com/MichaelHatherly/Docile.jl/tree/9e4400cceb561a35e708b94e33e3992298437d7a/src/Collector/docstrings.jl#L6)

