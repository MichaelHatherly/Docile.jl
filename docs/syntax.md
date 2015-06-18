# Writing Documentation

Docile provides two ways to document source code: the ``@doc`` macro (which is
available in Julia ``0.4-dev``), and plain strings. This guide will focus on the
latter syntax.

## The Basics

Documentation can be added to a method by writing a string literal, called a "docstring"
in this context, directly above it as follows:

```julia
" ... "
f(x) = x
```

The docstring ``" ... "`` will be associated with the ``Method`` object ``f(::Any)``.
Triple-quoted string literals, ``""" ... """``, are also supported:



```julia
"""
...
"""
f(x) = x
```

You may want to rather document the ``Function`` object instead of the ``Method`` when
writing a docstring:

```julia
f(x) = x

" ... "
f
```

Note that the docstring is written *after* the method definition. Trying to write the
following would result in an ``ERROR: UndefVarError: f not defined`` error since at the
point where ``f`` is referenced it has yet to be defined:

```julia
"Incorrect!"
f

f(x) = x
```

To over come this you can "quote" the function's name by using Julia's colon, ``:``,
syntax as shown in this example:

```julia
" ... "
:f

f(x) = x
```

From Julia ``0.4-dev+4989`` onward the syntax ``function <name> end`` is available
to define ``Function``s without adding any ``Method`` objects to them. They can be
documented in the same way as shown above:

```julia
" ... "
function f end
```

**Macros**, **types**, **bitstypes**, **inner constructors**, **typealiases**,
**modules**, and **globals** are documented in much the same way as for
``Function`` and ``Method`` objects. This example illustrates all of the
possible ways to document Julia code. The docstring text describes what is being
documented in each case:

```julia
module Example

"""
Module ``Example``.
"""
Example

"""
Method ``f(::Any)``.
"""
f(x) = x

"""
Function ``f`` after definition.
"""
f

"""
Function ``g`` prior to definition.
"""
:g

g(x) = x

"""
Abstract type ``AT``.
"""
abstract AT

"""
Type ``T``.
"""
type T
    x :: Int

    """
    Inner construtor ``T()``.
    """
    T() = new(1)
end

"""
Typealias ``TA``.
"""
typealias TA Int

"""
Bitstype ``BT``.
"""
bitstype 8 BT

"""
Macro ``@mac``.
"""
macro mac(x) end

"""
Constant ``K``.
"""
const K = 1

end
```

**Note:** Triple-quoted string literals have been used in the example above for the sake
of readability. Single line strings are just as applicable.

## Extras

At times the docstrings shown in the previous section may not be sufficient for an
author's needs. Docile supports several extensions in addition to the basics.

### Operators

All operators (``+``, ``*``, ``⊕``, etc.) must be enclosed in parentheses as shown below:

```julia
" ... "
(+)
```

As with named ``Function`` objects, operators may be quoted using ``:`` to allow the
docstring to appear prior to the definition:

```julia
" ... "
:(⊕)

(⊕)(a, b) = a + b * a - b
```

### Method Groups

```julia
f(x)            = x
f(x, y, z)      = x + y + z
f(x, y::Int, z) = x + y + z

" ... "
(f, Any, Int, Any)
```

The tuple syntax, ``(<function name>, <type 1>, ..., <type n>)``, associates the docstring
with all ``Method`` objects that match the provided type signature. The behaviour is
similar to the ``methods`` function. In the example shown above the docstring will be
associated with methods ``f(::Any, ::Any, ::Any)`` and ``f(::Any, ::Int, ::Any)``, but not
``f(::Any)``.

### Function Groups

```julia
f(x)  = x
f!(x) = x

" ... "
[f, f!]
```

The vector syntax associates the docstring with all the ``Function`` objects listed. It
can be useful when documenting a function that includes mutating and a non-mutating
versions whose documentation will naturally be quite similar.

### Generalised Groups

``Function`` and ``Method`` objects can be associated with the same
docstring by combining the syntax of the two previous sections:

```julia
f(x) = x
g(x) = x

" ... "
[f, (g, Any)]

" ... "
[(f, Any), g]
```

### External Documentation

The documentation for an object may, in some cases, be quite extensive and
thus interrupt the "flow" of code in a file. To help prevent this docstrings
may be referenced from external files as follows:

```julia
"../docs/f.md"
f(x) = x
```

The contents of the file ``../docs/f.md``, relative to the source file, is
used as the docstring associated with the ``Method`` object ``f(::Any)``.


### Asides

Some documentation isn't associated with any particular object in a source
file, but rather with the file itself or a certain section of one. Docile
has syntax for "aside" docstrings which don't associate with objects and can
be used to add additional information and commentary to the resulting
documentation. The syntax is as follows:

```julia
[" ... "]
```
