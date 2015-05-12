# Docile

Any questions about using this package? Ask them in the Gitter linked below:

[![Join the chat at https://gitter.im/MichaelHatherly/Docile.jl](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/MichaelHatherly/Docile.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**Documentation**

[![Stable Documentation][stable-docs-img]][stable-docs-url]
[![Latest Documentation][latest-docs-img]][latest-docs-url]

**Builds**

[![Build Status][travis-img]][travis-url]
[![Build status][appveyor-img]][appveyor-url]

**Package Status**

[![Coverage Status][coveralls-img]][coveralls-url]
[![Docile][pkgeval-img]][pkgeval-url]

## Overview

*Docile* is a [Julia](http://www.julialang.org) package documentation system.

It provides a macro, `@doc`, for documenting arbitrary Julia objects. This
functionality is equivalent to the new `@doc` macro available from `Base` in
Julia `0.4`.

Additionally, *Docile* has support for using plain strings for documentation
rather than using the `@doc` macro. See the package documentation for further
details.

## Installation

*Docile* supports both Julia `0.3` and `0.4` and can be installed via:

```julia
Pkg.add("Docile")
```

## Viewing Documentation

Package documentation is available for the [stable][stable-docs-url] and
[development][latest-docs-url] versions.

To view documentation from the REPL and generate external documentation for a
package please install the package [*Lexicon*][lexicon-url].

## Projects using Docile / Lexicon

* [AverageShiftedHistograms.jl](https://github.com/joshday/AverageShiftedHistograms.jl) David Scott's Average Shifted Histogram density estimation.
* [BDF.jl](https://github.com/sam81/BDF.jl) Module to read Biosemi BDF files with the Julia programming language.
* [BrainWave.jl](https://github.com/sam81/BrainWave.jl) Julia functions to process electroencephalographic recordings.
* [Diversity.jl](https://github.com/richardreeve/Diversity.jl) Julia package for diversity measurement.
* [Docile.jl](https://github.com/MichaelHatherly/Docile.jl) Julia package documentation system.
* [IterativeSolvers.jl](https://github.com/JuliaLang/IterativeSolvers.jl) Implement Arnoldi and Lanczos methods for svds and eigs.
* [Lexicon.jl](https://github.com/MichaelHatherly/Lexicon.jl) Julia package documentation generator.
* [SDT.jl](https://github.com/sam81/SDT.jl) Signal detection theory measures with Julia.
* [Sims.jl](https://github.com/tshort/Sims.jl) Experiments with non-causal, equation-based modeling in Julia.
* [TargetedLearning.jl](https://github.com/lendle/TargetedLearning.jl) General framework for constructing regular, asymptotically linear estimators for pathwise differentiable parameters.

If you use Docile / Lexicon please file an issue or send a pull request through GitHub to be listed here.

## Issues and Support

Please file any issues or feature requests you might have through the GitHub
[issue tracker][issue-tracker].

[travis-img]: https://travis-ci.org/MichaelHatherly/Docile.jl.svg?branch=master
[travis-url]: https://travis-ci.org/MichaelHatherly/Docile.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/ttlbaxp6pgknfru5/branch/master?svg=true
[appveyor-url]: https://ci.appveyor.com/project/MichaelHatherly/docile-jl/branch/master

[coveralls-img]: https://coveralls.io/repos/MichaelHatherly/Docile.jl/badge.svg?branch=master
[coveralls-url]: https://coveralls.io/r/MichaelHatherly/Docile.jl?branch=master

[pkgeval-img]: http://pkg.julialang.org/badges/Docile_release.svg
[pkgeval-url]: http://pkg.julialang.org/?pkg=Docile&ver=release

[issue-tracker]: https://github.com/MichaelHatherly/Docile.jl/issues

[docs-url]: https://MichaelHatherly.github.io/Docile.jl/index.html

[lexicon-url]: https://github.com/MichaelHatherly/Lexicon.jl

[latest-docs-img]: https://readthedocs.org/projects/docilejl/badge/?version=latest
[stable-docs-img]: https://readthedocs.org/projects/docilejl/badge/?version=stable

[latest-docs-url]: http://docilejl.readthedocs.org/en/latest/
[stable-docs-url]: http://docilejl.readthedocs.org/en/stable/
