# Syntax Summary

Docile provides two distinct ways to add docstrings to source code.

## @doc

This macro mirrors the behavior of the ``@doc`` macro provided in Julia 0.4
with two additional features.

### @doc+

The syntax:

```julia
@doc+ " ... " ->
f(x) = 2x
```

is used to add documentation to the ``Function`` object ``f`` while the syntax:

```julia
@doc " ... " ->
f(x) = 2x
```

adds the documentation to the ``Method`` object ``f(x)``.

### meta

Additional metadata can be added to a docstring by using the ``meta`` function as
follows:

```julia
@doc meta(" ... "; return_type => (Bool,)) ->
g(x) = x < 2
```

Arbitrary keyword arguments can be passed to the ``meta`` function. Keywords with
specific meaning are:

* ``file``: provides an file to use for the docstring's content.

## Plain strings

From Docile 0.4 onward plain strings are supported for use as docstrings.

### Setup

No setup is required to document a package using Docile. All that is needed is
for a package to follow the syntax discussed in the next section and then use
the [Lexicon.jl](https://github.com/MichaelHatherly/Lexicon.jl) package to view
the docstrings at the REPL and generate static documentation. See the Lexicon
documentation for details regarding this.

### Basics

Basic usage is as follows:

```julia
" ... "
f(x) = x

"""
...
"""
f(x, y) = x + y

" ... "
macro m(x)
    # ...
end

" ... "
type T
    # ...
end

" ... "
typealias MyAlias Int

" ... "
const MyConst = 1
```

This example adds documentation to the two methods ``f(x)`` and ``f(x, y)``.
Documentation is also added for the macro ``@m`` and type ``T``. ``typealias`` and
``const`` docstrings are also supported.

The docstrings themselves can be either single- or triple-quoted strings.
``@md_str`` and ``@md_mstr`` macros are provided should a docstring contain
characters (such as ``$``) that should be treated as literals.

### Functions

Adding documentation to a ``Function`` rather than a ``Method``, as in the previous
section, can be done as follows:

```julia
f(x) = 2x

" ... "
f
```

If one would rather write the docstring before the definition of ``f`` then
quote the function as in this example:

```julia
" ... "
:f

f(x) = 2x
```

### Inner constructors

A type's inner constructors can have individual docstrings by placing
a docstring above the construct as with ``Method`` docstrings:

```julia
" ... "
type MyType
    # fields...

    " ... "
    MyType() = new()

    " ... "
    MyType(x) = new(x)
end
```

### Grouped docstrings

Some docstrings may be applicable to multiple methods or functions. To
reduce duplication of effort special syntax is provided.

Documenting several methods with similar type signatures:

```julia
type MyObject
    # ...
end

f(::MyObject)    = ()
f(::MyObject, x) = ()

" ... "
(f, MyObject, Any...)
```

**Note:** As with documenting functions in the previous section, ``f`` can be
quoted to allow for the docstring to be written before the definitions.

Several functions can share the same docstring by using the following vector
syntax:

```julia
g(x)  = x
g!(x) = x

" ... "
[g, g!]
```

**Note:** Quoting the functions ``g`` and ``g!`` allow the docstring to appear
before the definitions.

Adding the same docstring to methods and functions with dissimilar signatures uses the
following syntax:

```julia
h(x::Int, y::Float64) = x + y
h(x::Float64, x::Int) = x + 2y
h(s::String, y::Int)  = s ^ y

" ... "
[(h, Int, Float64), h, (h, Float64, Int)]
```

In the previous example the docstring is added to the ``Function`` ``h`` as well as
the first two ``h`` methods, but not the last ``Method`` object.

### External docstrings

When a docstring refers to an external file it will be read in as the contents
of the docstring. The path must be relative to the source file in which the
docstring is written.

```julia
"../docs/methods/f.md"
f(x) = 2x
```

### Modules

A ``Module`` object can be documented using the same syntax as for ``Function``s:

```julia
module MyModule

" ... "
MyModule

# ...

end
```
