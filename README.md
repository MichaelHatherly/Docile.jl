# Docile

[![Build Status](https://travis-ci.org/MichaelHatherly/Docile.jl.svg?branch=master)](https://travis-ci.org/MichaelHatherly/Docile.jl)
[![Coverage Status](https://coveralls.io/repos/MichaelHatherly/Docile.jl/badge.png)](https://coveralls.io/r/MichaelHatherly/Docile.jl)

[Julia](www.julialang.org) package documentation system. [Mailing list discussion](https://groups.google.com/forum/#!topic/julia-users/k_SzJxcAoqA).

## Install

*Docile* is not registered in `METADATA` currently. Install it using:

```julia
julia> Pkg.clone("https://github.com/MichaelHatherly/Docile.jl")
```

## Usage

### Viewing Documentation

```julia
julia> using Docile
julia> @query doctest(Docile)
julia> query("Examples")
```

`@query` works in a similar manner to `Base.@which`, but displays any
documentation associated with the method that would have been called
with the given arguments.

A set of `query` methods also exist and behave in a *similar* way to
`Base.which`. The `query` method with a string argument does a full text
search.

```julia
julia> query(Docile, doctest)
julia> query(Docile, doctest, (Module,))
```

### Documenting Methods

Support for documenting methods is currently available. Macros, types,
etc. can't be documented.

Documenting methods in a package can be done as follows:

```julia
module PackageName

using Docile
@docstrings # Call before any `@doc` uses. Creates the module's `METADATA` object.

@doc """
# Heading 1
All text above the `+++` delimiter is parsed as markdown. Any legal
markdown syntax should be available.

## Subheading 1
You'll need to escape `\\` and `\$` since this is still a Julia string.

    fac(n::Integer) = n < 2 ? 1 : n * fac(n - 1)
    @assert fac(5) == 120

Blocks of code can be run using `Docile.doctest`.

* lists
* are
* allowed
* as
* well

Everything below the `+++` is parsed as YAML formatted text. Any legal
YAML syntax *should* be available to use. This metadata section is
stored as a Julia dictionary for later use.

**Note the `..` after the closing triplequotes.**

+++
tags: [foo, bar, baz]
""" ..
function func1(x, y)
    # ...
end

@doc """
Single line function declarations are also supported.

The markdown and YAML sections of a docstring may be left empty if
required, but the `+++` must always be included (this might change).
+++
""" ..
func2(x, y, z) = x + y + z

# more things ...

end
```

## Feedback

Any thoughts, requests, or PRs are welcome.

## Issues list

Some issues and discussion related to package documentation:

* [#762](https://github.com/JuliaLang/julia/issues/762)
* [#1619](https://github.com/JuliaLang/julia/pull/1619)
* [#3407](https://github.com/JuliaLang/julia/issues/3407)
* [#3988](https://github.com/JuliaLang/julia/issues/3988)
* [#4579](https://github.com/JuliaLang/julia/issues/4579)
* [#5200](https://github.com/JuliaLang/julia/issues/5200)
* and elsewhere on the mailing lists.
