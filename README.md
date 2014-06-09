# Docile

[![Build Status](https://travis-ci.org/MichaelHatherly/Docile.jl.svg?branch=master)](https://travis-ci.org/MichaelHatherly/Docile.jl)
[![Coverage Status](https://coveralls.io/repos/MichaelHatherly/Docile.jl/badge.png)](https://coveralls.io/r/MichaelHatherly/Docile.jl)

[Julia](www.julialang.org) package documentation system. [Mailing list discussion](https://groups.google.com/forum/#!topic/julia-users/k_SzJxcAoqA).

     help> Docile
    Docile.Docile

       An experimental package to provide documentation support for 3rd-party
       packages in the Julia ecosystem.

*Docile* modifies `Base.Help.init_help()` to load custom `helpdb.jl`
files into the help system that can then be viewed at the REPL or inline
in LightTable using [Jewel](https://github.com/one-more-minute/Jewel).

The documentation is parsed using [Markdown.jl](https://github.com/one-more-minute/Markdown.jl).

## Install

*Docile* is not in `METADATA` so clone it via:

    julia> Pkg.clone("https://github.com/MichaelHatherly/Docile.jl")

Add the following to your `.juliarc.jl` file:

    # top of .juliarc.jl
    import Docile
    Docile.patch!()

    # rest of file.

`patch!` re-evaluates `Base.Help.init_help` function, adding code to
load all `helpdb.jl` files in `Docile/cache`.

After adding those lines when you start Julia again you should see

    INFO: Patching Base.Help.init_help()...

## Usage

*Docile*'s functions are documented in [`doc/help/docile.md`](https://github.com/MichaelHatherly/Docile.jl/blob/master/doc/help/docile.md). You can read them there
or use the Julia help system to view them:

    julia> apropos("Docile")
      Docile.remove(package::String)
      Docile.update(packages::String...)
      Docile.patch!()
      Docile.generate(package::String)
      Docile.init(package::String)
      Docile

     help> Docile.update
    Docile.update(packages::String...)

      Run generate on all packages. If none are given then regenerate
      documentation for each package in Docile/cache.

      # generate documentation for "Docile.jl"
      julia> Docile.update("Docile")

      # update documentation for every cached package
      julia> Docile.update()

## Documentation Format

*Docile* uses plain markdown files for documentation. A `#` on the first
line of a file specifies the module being documented. Subsequent lines
beginning with `##` specify entries to be documented. Text between `##`s
is documentation for the most recent `##` line.

See [docile.md](https://github.com/MichaelHatherly/Docile.jl/blob/master/doc/help/docile.md) for examples.

## Feedback

Any thoughts, requests, clarifications, or PRs are very welcome.

## Issues list

* [#762](https://github.com/JuliaLang/julia/issues/762)
* [#1619](https://github.com/JuliaLang/julia/pull/1619)
* [#3407](https://github.com/JuliaLang/julia/issues/3407)
* [#3988](https://github.com/JuliaLang/julia/issues/3988)
* [#4579](https://github.com/JuliaLang/julia/issues/4579)
* [#5200](https://github.com/JuliaLang/julia/issues/5200)
* and elsewhere on the mailing lists.
