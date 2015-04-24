# Docile

## Exported
---

### meta()
Add additional metadata to a documented object.

`meta` takes arbitrary keyword arguments and stores them internally as a
`Dict{Symbol,Any}`. The optional `doc` argument defaults to an empty string if
not specified.

**Examples:**

The syntax previously used (in versions prior to `0.3.2`) was

```julia
@doc "Documentation goes here..." [ :returns => (Int,) ] ->
foobar(x) = 2x + 1

```

This now becomes

```julia
@doc meta("Documentation goes here...", returns = (Int,)) ->
foobar(x) = 2x + 1

```

Specifying an external file as documentation can be done in the following way:

```julia
@doc meta(file = "../my/external/file.md") ->
foobar(x) = 2x + 1

```

**Note:** the `file` path is relative to the current source file.


*source:*
[Docile/src/docstrings.jl:88](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/docstrings.jl#L88)

---

### meta(doc)
Add additional metadata to a documented object.

`meta` takes arbitrary keyword arguments and stores them internally as a
`Dict{Symbol,Any}`. The optional `doc` argument defaults to an empty string if
not specified.

**Examples:**

The syntax previously used (in versions prior to `0.3.2`) was

```julia
@doc "Documentation goes here..." [ :returns => (Int,) ] ->
foobar(x) = 2x + 1

```

This now becomes

```julia
@doc meta("Documentation goes here...", returns = (Int,)) ->
foobar(x) = 2x + 1

```

Specifying an external file as documentation can be done in the following way:

```julia
@doc meta(file = "../my/external/file.md") ->
foobar(x) = 2x + 1

```

**Note:** the `file` path is relative to the current source file.


*source:*
[Docile/src/docstrings.jl:88](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/docstrings.jl#L88)

---

### @comment(text)
Add additional commentary to source code unrelated to any particular object.

**Example:**

```julia
@comment """
...
"""
```


*signature:*
comment(text)

*source:*
[Docile/src/docstrings.jl:51](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/docstrings.jl#L51)

---

### @doc(args...)
Document objects in source code such as *functions*, *methods*, *macros*,
*types*, *globals*, and *modules*.

Takes a string as documentation or a `meta` object containing a docstring and/or
additional metadata. See `meta` for further details.

**Examples:**

```julia
@docstrings

@doc "A single line method docstring with no metadata." ->
f(x) = x

@doc meta("A single line macro docstring with some arbitrary metadata.",
          author = "Author Name") ->
macro g(x)
    x
end

@doc """
A longer docstring for a type in a triple quoted string with no metadata.
""" ->
type F
    # ...
end

@doc meta("""
A triple quoted docstring for a global with metadata.
""", status = (:deprecated, v"0.1.0")) ->
const ABC = 1

value = "interpolated"

@doc """
Since docstrings are just normal strings values can be $(value) into
them from the surrounding scope or calculated, $(rand()), when the
module is loaded.
""" ->
immutable G
    # ...
end

```

### Documenting Functions and Methods

Adding documentation to a `Function` rather than a specific `Method` can be
achieved in two ways.

**Case 1**

Documentation may be added *after* the first definition of a method. In the
following example documentation is added to the method `f(x)` and then to the
generic function `f`.

```julia
@doc "Method specific documentation." ->
function f(x)
    x
end

@doc "Documentation for generic function `f`." -> f

```

*Note:* The `f` may be written directly after the `->` or on the subsequent
line.

**Case 2**

There may only be generic documentation for a function and none that is
method-specific. In this case the generic documentation may be written directly
above one of the methods by using `@doc+`. The documentation will then be
associated with the `Function` object rather than that particular `Method`.

```julia
@doc+ "Generic documentation for this function." ->
function f(x)
    x
end

```

### Documentation Formatting and Interpolation

Currently the only supported format for docstrings is markdown as provided by
the Markdown.jl package.

By default all docstrings will be stored in `Docs{:md}` types. This default may
be changed (once other formats become available) using the `@docstring` macro
metadata (see [@docstrings](#@docstrings) for details).

Since `$` and `\` are not interpreted literally in strings, string macros
`@md_str` and `@md_mstr` are provided to make it easier to enter LaTeX equations
in docstrings. The [@md_str](#@md_str) entry provides details.


*signature:*
doc(args...)

*source:*
[Docile/src/macros.jl:246](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/macros.jl#L246)

---

### @docstrings(args...)
Module documentation initialiser. Optional.

The macro creates the required `Documentation` object used to store a module's
docstrings. When no `@docstrings` in provided the first `@doc` usage will
automatically generate the required `Documentation` object without additional
metadata.

**Example:**

```julia
using Docile
@docstrings(manual = ["../doc/manual.md"])

```

Available keywords are `manual` and `format`. Others will become available in
the future.

`format` specifies the default format to use for all docstrings in a module.
`:md` is the default format.

`manual` is a vector of files that make up a module's manual section. The paths
must be specified relative to the source file where `@docstrings` is called
from.

The manual sections may be viewed using the `manual` function from
[Lexicon.jl](https://github.com/MichaelHatherly/Lexicon.jl) and are included in
the HTML documentation generated by *Lexicon*.


*signature:*
docstrings(args...)

*source:*
[Docile/src/macros.jl:144](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/macros.jl#L144)

---

### @document(options...)
Macro used to setup documentation for the current module.

Keyword arguments may be given to either override default module-level
metadata or to provide additional key/value pairs.

**Examples:**

```julia
using Docile
@document

```

```julia
using Docile
@document(manual = ["../docs/manual.md"])

```


*signature:*
document(options...)

*source:*
[Docile/src/Docile.jl:93](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/Docile.jl#L93)

---

### @file_str(path)
Provide a file path to the contents of a docstring.

The path is relative to the current source code file where the macro is called
from. The docstring format is decided based on the file extension provided. For
files written in markdown the extension must be `.md`.

**Example:**

```julia
file"../docs/foobar.md"
foobar(x) = 2x

```


*signature:*
file_str(path)

*source:*
[Docile/src/docstrings.jl:35](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/docstrings.jl#L35)

## Internal
---

### addentry!
Add object or set of objects and corresponding `Entry` object to a module.

*source:*
[Docile/src/builddocs.jl:92](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L92)

---

### builddocs!(meta)
Parse `root` and `files`, adding available docstrings to `objects`.

*source:*
[Docile/src/builddocs.jl:7](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L7)

---

### call(::Type{Docile.Manual}, ::Void, files)
Usage from REPL, use current directory as root.

*source:*
[Docile/src/types.jl:107](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L107)

---

### call(::Type{Docile.Metadata}, root::AbstractString, data::Dict{K, V})
Convenience constructor for `Metadata` type that initializes default values for
most of the type's fields.


*source:*
[Docile/src/Docile.jl:45](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/Docile.jl#L45)

---

### call{category}(::Type{Docile.Entry{category}}, modname::Module, source, doc::AbstractString)
Convenience constructor for simple string docs.

*source:*
[Docile/src/types.jl:75](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L75)

---

### call{category}(::Type{Docile.Entry{category}}, modname::Module, source, doc::Docile.Docs{format})
For md"" etc. -style docstrings.

*source:*
[Docile/src/types.jl:82](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L82)

---

### call{category}(::Type{Docile.Entry{category}}, modname::Module, source, tup::Tuple)
Handle the `meta` method syntax for `@doc`.

*source:*
[Docile/src/types.jl:61](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L61)

---

### call{format}(::Type{Docile.Docs{format}}, data::AbstractString)
Lazy `obj` field access which leaves the `obj` field undefined until first accessed.

*source:*
[Docile/src/types.jl:21](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L21)

---

### call{format}(::Type{Docile.Docs{format}}, docs::Docile.Docs{format})
Pass `Doc` objects straight through. Simplifies code in `Entry` constructors.

*source:*
[Docile/src/types.jl:24](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L24)

---

### call{format}(::Type{Docile.Docs{format}}, file::Docile.File)
Read a file's contents as the docstring.

*source:*
[Docile/src/types.jl:27](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L27)

---

### docstar(symb::Symbol, args...)
Attaching metadata to the generic function rather than the specific method which
the ``@doc`` is applied to.


*source:*
[Docile/src/macros.jl:87](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/macros.jl#L87)

---

### exec(state::Docile.State, ex::Expr)
Execute expression `ex` in the context provided by `state`.

Given an `Expr` and an a `State` object we walk the expression tree replacing
symbols with their actual values as determined by the provided `state` variable.

This method's main purpose is to evaluate method signatures and is *not*
designed to act as a replacement for `eval` in any way.

Some expression classes that `exec` should be able to interpret are:

* Symbols defined in a module or scope provided by the `state` object.
* Qualified names, ie. `MyModule.foo`.
* Method and macro calls.
* Type parameters.
* Vararg syntax.
* Tuples and vectors (both `hcat` and `vcat`).
* Basic indexing syntax with unnested `end` and `:`.
* String interpolation.
* `:` range syntax (both `a:b` and `a:b:c`).
* `$` interpolation for simple `@eval`-style code generation in for-loops.
* Constants.

**Example:**

```julia
vec = [1, 2, 3]

state = Docile.State(current_module())

Docile.exec(state, :(vec[1:2]))
Docile.exec(state, :(1 + 2 + 3))
Docile.exec(state, :("This is a vector: $(vec)"))
Docile.exec(state, :(Union(Vector{Int}, Array{Float64, 3})))
```


*source:*
[Docile/src/method-lookup.jl:138](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L138)

---

### externaldocs(mod, meta)
Guess doc format from file extension. Entry docstring created when file does not exist.

*source:*
[Docile/src/types.jl:34](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L34)

---

### findmethods(state::Docile.State, ex::Expr)
Return set of methods defined by an expression `ex` as if it had been evaluated.

For methods with `n` optional arguments the method returns all those `n` methods
defined by the expression `ex`. `findmethods` handles type parameters in inner
constructors correctly if they have already been pushed into the `state`'s scope
stack.

When no methods are found to match an expression then an error is raised.

**Example:**

```julia
foobar(x, y = 1) = x + y
state = Docile.State(current_module())
Docile.findmethods(state, :(foobar(x, y = 1) = x + y))
```


*source:*
[Docile/src/method-lookup.jl:265](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L265)

---

### findmodule(ast, modname)
Recursively walk an expression searching for a module with the correct name.

*source:*
[Docile/src/builddocs.jl:204](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L204)

---

### findsource(obj)
Returns the line number and filename of the documented object. This is based on
the ``LineNumberNode`` provided by ``->`` and is sometimes a few lines out.


*source:*
[Docile/src/macros.jl:101](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/macros.jl#L101)

---

### findtuples(state::Docile.State, ex::Expr)
Get all methods from a quoted tuple of the form `(function, T1, T2, ...)`.

*source:*
[Docile/src/method-lookup.jl:344](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L344)

---

### format(file)
Extract the format of a file based *solely* of the file's extension.

*source:*
[Docile/src/types.jl:43](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L43)

---

### funccall(ex::Expr)
Extract the `Expr(:call, ...)` from the given `ex`.

*source:*
[Docile/src/method-lookup.jl:59](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L59)

---

### funcname(state::Docile.State, ex::Expr)
Return the `Function` object contained in expression `ex`.

This method can handle single line function expressions, standard
`function ... end` expressions, ones containing type parameters, and will
also extract the `Function` object from method calls.

`$` interpolated expressions are also handled for cases where the expression is
evaluated in a for-loop containing `@eval`.

**Example:**

```julia
f(x) = 2x

state = Docile.State(current_module())

Docile.funcname(state, :(f(x) = 2x))
Docile.funcname(state, :(f(x)))
```


*source:*
[Docile/src/method-lookup.jl:91](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L91)

---

### getargs(ex::Expr)
Extract quoted argument expressions from a method call expression.

*source:*
[Docile/src/method-lookup.jl:68](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L68)

---

### getdoc(modname)
Return the Metadata object stored in a module.

*source:*
[Docile/src/types.jl:161](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L161)

---

### gettvars(ex::Expr)
Extract quoted type parameters from an expression.

*source:*
[Docile/src/method-lookup.jl:65](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L65)

---

### include!(meta, path)
Method used to override the behavior of `include`.

`include!` caches the full path of the included file in a module's `Metadata`
object and then passes `path` argument onto `Base.include_from_node1` method
as with the usual behavior of `Base.include`.


*source:*
[Docile/src/Docile.jl:66](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/Docile.jl#L66)

---

### includedast(meta)
Extract docstrings from the AST of included files.

*source:*
[Docile/src/builddocs.jl:20](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L20)

---

### isdocblock(block)
Is the given triplet `block` a valid documentation block.

*source:*
[Docile/src/builddocs.jl:170](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L170)

---

### issymbol(s::Symbol)
Handle modules and functions as symbols at later stage.

*source:*
[Docile/src/macros.jl:35](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/macros.jl#L35)

---

### lateguess(curmod, symb)
What does the symbol ``symb`` represent in the current module ``curmod``?

*source:*
[Docile/src/macros.jl:39](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/macros.jl#L39)

---

### macroname(ex)
Symbol representing a macro call to the specified macro `ex`.

*source:*
[Docile/src/builddocs.jl:167](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L167)

---

### name(ex::Expr)
Extract the symbol identifying an expression.

*source:*
[Docile/src/macros.jl:48](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/macros.jl#L48)

---

### object_category(ex)
What does the expression `ex` represent? Can it be documented? :symbol is used
to resolve functions and modules in the calling module's context -- after `@doc`
has returned.


*source:*
[Docile/src/macros.jl:6](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/macros.jl#L6)

---

### object_ref(cat, meta, state, ex)
Get the object/objects created by an expression in the given module.

*source:*
[Docile/src/builddocs.jl:148](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L148)

---

### parsefile(file)
Read contents of `file` and parse it into an expression.

*source:*
[Docile/src/builddocs.jl:4](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L4)

---

### popref!(state::Docile.State)
Remove the object from the top of `state`'s index references stack.

*source:*
[Docile/src/method-lookup.jl:44](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L44)

---

### popscope!(state::Docile.State)
Remove the scope from the top of `state`'s scopes stack.

*source:*
[Docile/src/method-lookup.jl:38](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L38)

---

### postprocess_entry!(cat::Symbol, meta, ent, ex)
Add additional metadata to an entry based on the category of the entry.

*source:*
[Docile/src/builddocs.jl:161](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L161)

---

### processast(meta, state, file, ex::Expr)
Gather valid documentation from a given expression `ex`.

*source:*
[Docile/src/builddocs.jl:32](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L32)

---

### processblock(meta, state, file, block)
Collect object and docstring `Entry` object from a valid documentation block.

*source:*
[Docile/src/builddocs.jl:114](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L114)

---

### pushmeta!(doc::Docile.Metadata, object, entry::Docile.Entry{category})
Warn the author about overwritten metadata.

*source:*
[Docile/src/types.jl:129](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L129)

---

### pushref!(state::Docile.State, object)
Push an object onto the top of a `state`'s index references stack.

*source:*
[Docile/src/method-lookup.jl:41](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L41)

---

### pushscope!(state::Docile.State, scope::Dict{K, V})
Add a new scope to top of `state`'s stack of scopes.

*source:*
[Docile/src/method-lookup.jl:35](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L35)

---

### qualifiedname(ex::Expr)
Returns as a tuple the module name as well as the full method name.

*source:*
[Docile/src/macros.jl:58](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/macros.jl#L58)

---

### readdocs(file)
Load and apply format based on extension to the given `filename`.

*source:*
[Docile/src/types.jl:40](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L40)

---

### register!(modname)
Register a module `modname` as 'documented' with Docile.

*source:*
[Docile/src/Docile.jl:15](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/Docile.jl#L15)

---

### rootast(meta)
Extract docstrings from the AST found in the root file of a module.

*source:*
[Docile/src/builddocs.jl:10](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/builddocs.jl#L10)

---

### separate(expr)
Split the expressions passed to `@doc` into data and object. The docstring and
metadata dict in the first tuple are the data, while the second returned value
is the actual piece of code being documented.


*source:*
[Docile/src/macros.jl:72](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/macros.jl#L72)

---

### setmeta!(modname, object, category, source, args...)
Metatdata interface for *single* objects. `args` is the docstring and metadata dict.

*source:*
[Docile/src/types.jl:138](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L138)

---

### setmeta!(modname, objects::Set{T}, category, source, args...)
For varargs method definitions since they generate multiple method objects. Use
the *same* Entry object for each object's documentation.


*source:*
[Docile/src/types.jl:152](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L152)

---

### unravel(entries, meta, state, file, ex::Expr)
Execute for-loops containing `@eval` blocks and retrieve documented objects.

When an `Expr(:for, ...)` is encountered do the following:

* Walk inner expressions to find `@eval` blocks. Return if none found.
* For each multi argument loop expand it into nested loops.
* Execute the outer most loop's variable and loop over the value returned.
* For each loop iteration push new scope onto `state` containing value of loop variable.
* Recursively expand the inner loop expressions with this new scope and execute it.
* Pop the current loop iteration's scope after loop has been completed.


*source:*
[Docile/src/method-lookup.jl:384](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L384)

---

### Docile.Docs{format}
Lazy-loading documentation object. Initially the raw documentation string is
stored in `data` while `obj` field remains undefined. The parsed documentation
AST/object/etc. is cached in `obj` on first request for it. `format` is a
symbol.


*source:*
[Docile/src/types.jl:16](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L16)

---

### Docile.Entry{category}
Type representing a docstring and associated metadata in the
module's `Documentation` object.

The `Docile.Interface` module (documentation available
[here](interface.html)) provides methods for working with `Entry`
objects.


*source:*
[Docile/src/types.jl:55](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/types.jl#L55)

---

### Docile.Metadata
Container type used to store a module's metadata collected by Docile.

Each module documented using Docile contains an instance of this object created
using the `@document` macro.

**Fields:**

* `modname`: The module where this object is defined.
* `entries`: Dictionary containing `object => Entry` pairs.
* `root`: The full directory path to a module's location.
* `files`: Set of all files `include`d in a module.
* `data`: Additional metadata collected during module parsing.
* `loaded`: Has the module been parsed and metadata collected?


*source:*
[Docile/src/Docile.jl:32](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/Docile.jl#L32)

---

### Docile.State
The `State` type holds the data for evaluating expressions using `exec`.

**Fields:**

* `mod`: The module object where expressions will be evaluated.
* `scopes`: Stack of local variables defined by for-loops and type parameters.
* `refs`: Stack of objects being indexed into to handle `end` and `:` uses.

**Example:**

```julia
state = Docile.State(Main)
```


*source:*
[Docile/src/method-lookup.jl:25](https://github.com/MichaelHatherly/Docile.jl/tree/02f3e73f51ad2cfca9328331d06e23538f4e99e8/src/method-lookup.jl#L25)

