# Docile

## init(package::String)

Create a default directory layout that Docile understands in
`.julia/v0.3/<package>/doc`. A `doc/help` subdirectory stores all the
markdown formatted documentation files. A `doc/docile.jl` file is
created as well to make documentation generation easier.

See the `.julia/v0.3/Docile/doc` folder for further details.

    # initialize documentation folders for Docile.jl use
    julia> Docile.init("Docile")

    # make `cache/Docile/helpdb.jl` from commandline
    $ cd .julia/v0.3/Docile/doc
    $ julia docile.jl

## generate(package::String)

Parse all markdown files in `doc/help` directory of `package` and
generate a `helpdb.jl` in `Docile/cache/<package>/`. The generated file
should be compatible with the official Julia version. The cached files
can be loaded into help system for interactive use.

    # Cache help files for Docile package.
    julia> Docile.generate("Docile")

## update(packages::String...)

Run `generate` on all `packages`. If none are given then regenerate
documentation for each package in `Docile/cache`.

    # generate documentation for "Docile.jl"
    julia> Docile.update("Docile")

    # update documentation for every cached package
    julia> Docile.update()

## remove(package::String)

Delete `<package>/doc` folder from `package`. All subdirectories and
files are deleted as well.

    julia> Docile.remove("Docile")

## patch!()

Monkey-patch the help system in `Base.Help` to load custom `helpdb.jl`
files. This should be run at start-up by placing the following in
`.juliarc.jl` at the start of the file.

    # start of .juliarc.jl
    import Docile
    Docile.patch!()

    # rest of file ...
