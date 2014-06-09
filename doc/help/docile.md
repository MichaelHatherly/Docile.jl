# Docile

## Docile

An *experimental* package to provide documentation support for 3rd-party
packages in the [Julia](www.julialang.org) ecosystem.

## init(package::String)

Create a default directory layout that Docile understands in
`.julia/v0.3/<package>/doc`.

A `doc/help` subdirectory stores all the markdown formatted
documentation files. A `doc/docile.jl` file is created as well to make
documentation generation easier from the commandline.

    # initialize documentation folders for Docile.jl use
    julia> Docile.init("Docile")

    # make `cache/Docile/helpdb.jl` from commandline
    $ cd .julia/v0.3/Docile/doc
    $ julia docile.jl

See the `.julia/v0.3/Docile/doc` folder for further details.

## build(packages::String...)

Build documentation for all `packages`. If none are given then rebuild
documentation for each package in `Docile/cache`.

    # generate documentation for "Docile.jl"
    julia> Docile.build("Docile")

    # update documentation for every cached package
    julia> Docile.build()

### Details

The build process involves parsing all markdown files in
`<package>/doc/help` and generating a `helpdb.jl` in
`Docile/cache/<package>/`. The generated file should be compatible with
the official Julia version. Cached files can then be loaded into help
system for interactive use.

## remove(package::String)

Uninstall *Docile* from the given `package`.

    julia> Docile.remove("Docile")

### Details

`<package>/doc/help` and `docile.jl` are removed along with `doc` if
nothing else is found there. The cache in `Docile/cache/<package>` is
also removed.

## patch!()

Monkey-patch the help system in `Base.Help` to load custom `helpdb.jl`
files. This should be run at start-up by placing the following in
`.juliarc.jl` at the start of the file.

    # start of .juliarc.jl
    import Docile
    Docile.patch!()

    # rest of file ...
