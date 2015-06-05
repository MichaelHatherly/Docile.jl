*Docile* is a [Julia](http://www.julialang.org) package documentation system that provides
a docstring macro, `@doc`, for documenting arbitrary Julia objects and associating
metadata with them.

### Installation

The package is in `METADATA` and can be installed via `Pkg.add("Docile")`.

### Overview

The `@doc` macro can be used to document *functions*, *globals*, *macros*, *methods*,
*modules*, and *types*. The following example illustrates some basic usage of the macro.

```julia
module PackageName

using Docile
@docstrings

@doc " ... " ->
function f(x)
    # ...
end

@doc """
...
""" ->
g(x) = x

end
```

**Explanation:**

The *Docile* package is loaded with `using Docile` and the current module's documentation
is initialised via the `@docstrings` macro.

The `@doc` macro is then be used to attach documentation to the methods `f(x)` and `g(x)`.

Note that the `->` is required between the string and the object being documented and it
must appear on the same line as the closing `"`.

A more in-depth discussion covering metadata, formatted docstrings, and documenting
generic functions can be found in the entry for [@doc](#@doc).

### Backwards compatibility with julia 0.4's `@doc`

Julia 0.4 includes a documentation system whose design was based on Docile.
If you want to leverage the built-in mechanism on julia 0.4, change the

```julia
using Docile
```

to

```julia
if VERSION < v"0.4.0-dev"
    using Docile
end
```

Note that some Docile features, like `@doc+`, are not present in julia 0.4.

### Loading Documented Modules

Docile is designed to document whole packages rather than individual source files.
This means that calling ``include("mymodule.jl")`` where ``"mymodule.jl"`` contains:

```julia
module MyModule

# ...

end
```

will not pickup any of ``MyModule``'s docstrings.

**The solution** is to either make the file ``"mymodule.jl"`` into a proper
Julia package using ``Pkg.generate`` so that ``using MyModule`` works, or use
``require`` instead of ``include`` when loading the file.
