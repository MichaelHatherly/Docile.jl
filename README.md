# Docile

[![Build Status][travis-img]][travis-url]
[![Build status][appveyor-img]][appveyor-url]
[![Coverage Status][coveralls-img]][coveralls-url]
[![Docile][pkgeval-img]][pkgeval-url]

*Docile* is a [Julia](www.julialang.org) package documentation system
that provides a docstring macro, `@doc`, for documenting arbitrary Julia
objects and associating metadata with them.

**Note:** the query and display functionality has been moved to
[Lexicon.jl][lexicon-url].

### Installation

*Docile* currently supports Julia `0.3/0.4` and is available from `METADATA` via:

```julia
Pkg.add("Docile")
```

### Documentation

*Lexicon.jl*-generated documentation is available for:

**Stable (0.2.0):**

[`Docile`][docile-stable-url]

[`Docile.Interface`][docile-interface-stable-url]

**Master:**

[`Docile`][docile-master-url]

[`Docile.Interface`][docile-interface-master-url]

### Issues and Support

Please file any issues or feature requests you might have through the GitHub [issue tracker][issue-tracker].

[travis-img]: https://travis-ci.org/MichaelHatherly/Docile.jl.svg?branch=master
[travis-url]: https://travis-ci.org/MichaelHatherly/Docile.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/ttlbaxp6pgknfru5/branch/master
[appveyor-url]: https://ci.appveyor.com/project/MichaelHatherly/docile-jl/branch/master

[coveralls-img]: https://coveralls.io/repos/MichaelHatherly/Docile.jl/badge.png
[coveralls-url]: https://coveralls.io/r/MichaelHatherly/Docile.jl

[pkgeval-img]: http://pkg.julialang.org/badges/Docile_release.svg
[pkgeval-url]: http://pkg.julialang.org/?pkg=Docile&ver=release

[issue-tracker]: https://github.com/MichaelHatherly/Docile.jl/issues

[docile-stable-url]:           https://MichaelHatherly.github.io/Docile.jl/stable/docile.html
[docile-interface-stable-url]: https://MichaelHatherly.github.io/Docile.jl/stable/interface.html

[docile-master-url]:           https://MichaelHatherly.github.io/Docile.jl/master/docile.html
[docile-interface-master-url]: https://MichaelHatherly.github.io/Docile.jl/master/interface.html

[lexicon-url]: https://github.com/MichaelHatherly/Lexicon.jl
