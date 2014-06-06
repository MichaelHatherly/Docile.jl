# Docile

[![Build Status](https://travis-ci.org/MichaelHatherly/Docile.jl.svg?branch=master)](https://travis-ci.org/MichaelHatherly/Docile.jl)
[![Coverage Status](https://coveralls.io/repos/MichaelHatherly/Docile.jl/badge.png)](https://coveralls.io/r/MichaelHatherly/Docile.jl)

***Experimental*** [Julia](www.julialang.org) package documentation system.

*Docile* hooks into `Base.Help.init_help()` to load custom `helpdb.jl`
files into the help system that can then be viewed at the REPL or inline
in LightTable using the [Jewel plugin](https://github.com/one-more-minute/Jewel). Possibly in [IJulia](https://github.com/JuliaLang/IJulia.jl) as well,
but untested currently.

This package is ***not*** meant for general use (at this stage),
but was rather written as a proof of concept to generate further
discussion on the Documentation Issue. See list at end.

## Install

*Docile* is not in `METADATA` so clone it (at your own risk) via:

    julia> Pkg.clone("https://github.com/MichaelHatherly/Docile.jl")

## Usage

The functions that *Docile* exports are documented in
`doc/help/docile.md`. You can read them there since they are simple
markdown files.

The documentation format is as follows:

* First line contains an H1 header `# ` with full module path. For example: `# Base.LinAlg` or `# Docile` or `# Really.Long.Module.Path`.
* A blank line in left between each entry.
* Entries begin with H2 headers `## ` for function or macro signatures. The same style used in `Base` may be used. Example: `## init(package::String)`
* The content of each entry is completely free-form. Have a look at `doc/help/docile.md` for examples.

You can have any number of markdown files in `doc/help`. Only files with
`.md` extension are parsed by *Docile*. Different files can have the
same first line header if you find that a single file is getting too
long for the number of documented functions in the module.

### Generating documentation

To generate the documentation for the *Docile* package use:

    julia> using Docile
    julia> Docile.generate("Docile")

To get Julia to load the custom `helpdb.jl` generated in the previous
step add the following to your `.juliarc.jl` file.

    # top of .juliarc.jl
    import Docile
    Docile.patch!()

    # rest of file.

`patch!` re-evaluates the built-in `Base.Help.init_help` function, adding
code to load all `helpdb.jl` files in `Docile/cache`. This isn't a great
solution (or one that should be done at all).

**The main purpose of this package is to discuss whether this
functionality should be included in `Base.Help.init_help`.**

After adding those lines when you start Julia again you should see

    INFO: Patching Base.Help.init_help()...

appear on start-up. You can then search the built-in help for documentation
related to *Docile*.

    julia> apropos("Docile")
    INFO: Loading help data...
    Docile.remove(package::String)
    Docile.update(packages::String...)
    Docile.patch!()
    Docile.generate(package::String)
    Docile.init(package::String)

and use the `?` help system:

     help> "patch!"
    Docile.patch!()

       Monkey-patch the help system in `Base.Help` to load custom `helpdb.jl`
       files. This should be run at start-up by placing the following in
       `.juliarc.jl` at the start of the file.

           # start of .juliarc.jl
           import Docile
           Docile.patch!()

           # rest of file ...

This currently only works with strings as can be seen in the following:

     help> patch!
    ERROR: patch! not defined
    julia> using Docile
     help> patch!
    ERROR: Docile not defined
     in eval at no file
     in help at help.jl:102
     in help at help.jl:165
     in help at help.jl:180

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
