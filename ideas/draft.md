# Wanted features

*Note: It would appear after writting this that I want Sphinx (or some
subset) written in Julia.*

*There's some overlapping between ideas below and other Julia projects,
so don't do unnessesary extra work.*

## Stacked entries

Example from `DataFrames` documentation:

    ## size(x::DataArray)
    ## length(x::DataArray)
    ## ndims(x::DataArray)
    ## ref(x::DataArray)
    ## assign(x::DataArray)
    ## start(x::DataArray)
    ## next(x::DataArray)
    ## done(x::DataArray)

    Same behaviour as for arrays.

An entry is created for each `##` line and the body text after is added
to each one. Save typing.

## Multiple `#` headers in a file

For small packages that have multiple submodules it would be nice to
just have a single help file for simplicity.

Example

    # MODULE_NAME

    ... entries

    # MODULE_NAME.SUBMODULE

    ... entries

    # MODULE_NAME.OTHER_SUBMODULE

    ... entries

## Inline documentation

Extract multiline comments from source files and create documentation
entries in the same way as with external help files.

Possible syntax using `!` to differentiate from standard multiline
comments:

    #=!

    Formatted documentation goes here...

    =#
    function foo(bar, baz)
        # ...
    end

## Allow subdirectories in `doc/help`

Just an oversight. Search through subdirectories recursively.

## Useful filenames

Use the filename as the true header for that section of documentation
when creating HTML or PDF output.

Possible issue with spaces in filenames?

## Custom CSS

When creating HTML documentation from help files use a css file that
makes `H1` and `H2` headers more suitable, ie. smaller font, monospaced
to make clear what they are (functions/macros...).

## LaTeX

Ouput LaTeX from Markdown.jl. MathJax for HTML.

## Manual

Add a manual folder as `doc/manual`. In `doc/docile.jl` have something
like the following:

    import Docile
    manual = [
        "intro.md",
        ...
    ]
    Docile.build(PACKAGE_NAME, manual)

Manual index would be specified via the order of the `manual` vector.
Whether to build the manual or not would be determined via `ARGS`.

Perhaps do the same for the help files.

## Links

Allow (auto)linking to entries from other entries and the manual.

## Run code

For testing and correctness purposes. Display results of computations.

## Documentation coverage

There may be something in `Base` already that does something similar.

Stats about number of undocumented functions in package. Entries
without examples. Others...
