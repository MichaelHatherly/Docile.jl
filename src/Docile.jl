module Docile

"""
!!summary(Documentation extraction package for the Julia Language.)

Docile supports several styles of docstring. Namely:

The original ``@doc`` macro, which is now also available in Julia ``0.4``:

    using Docile

    @doc \"\"\"
    ...
    \"\"\" ->
    f(x) = x

Plain strings using the ``@document`` macro. Requires importing ``Docile`` into
the module:

    using Docile
    @document

    \"\"\"
    ...
    \"\"\"
    f(x) = x

Automatic extraction for plain docstrings from packages that have been
``import``ed:

    \"\"\"
    ...
    \"\"\"
    f(x) = x

The third style is the newest, and preferred, way to document packages in a
Docile-compatible way. ``@doc`` and ``@document`` docstring usage will remain
part of Docile for the foreseeable future to allow for backward compatibility.
"""
Docile

include("Utilities.jl")                          # Code useful across submodules.

include(joinpath("Formats", "Formats.jl"))       # Format-dispatch for parsing docstrings.

include(joinpath("Runner", "Runner.jl"))         # Execute expressions.
include(joinpath("Collector", "Collector.jl"))   # Collect information from modules.

include(joinpath("Cache", "Cache.jl"))           # Store collected information.

include(joinpath("Legacy", "Legacy.jl"))         # Compatibility with base and docile.
include(joinpath("Interface", "Interface.jl"))   # Public interface to the package.

include(joinpath("Extensions", "Extensions.jl")) # Additional formatters and parsers.

## Direct Exports. ##

import .Legacy:

    @doc, @comment,

    @document, @docstrings,

    @doc_str, @doc_mstr, @file_str, @md_str, @md_mstr,

    meta

export

    @doc, @comment,

    @document, @docstrings,

    @doc_str, @doc_mstr, @file_str, @md_str, @md_mstr,

    meta,

    Interface

end
