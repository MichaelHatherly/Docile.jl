Module documentation initialiser. Run this macro prior to any `@doc`
uses in a module.

Creates the required `Documentation` object used to store a module's
docstrings.

**Examples:**

```julia
using Docile
@docstrings
```

An optional list of file names may be provided for inclusion in the
manual section of the documentation, which can be viewed using the
`manual` function from
[Lexicon.jl](https://github.com/MichaelHatherly/Lexicon.jl).

```julia
using Docile
@docstrings {"../doc/manual.md"}

```
