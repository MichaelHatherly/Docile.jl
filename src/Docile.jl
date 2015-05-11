module Docile

include("Utilities.jl")                          # Code useful across submodules.

include(joinpath("Formats", "Formats.jl"))       # Format-dispatch for parsing docstrings.

include(joinpath("Runner", "Runner.jl"))         # Execute expressions.
include(joinpath("Collector", "Collector.jl"))   # Collect information from modules.

include(joinpath("Cache", "Cache.jl"))           # Store collected information.

include(joinpath("Legacy", "Legacy.jl"))         # Compatibilty with base and docile.
include(joinpath("Interface", "Interface.jl"))   # Public interface to the package.

include(joinpath("Extensions", "Extensions.jl")) # Additional formatters and parsers.

## Direct Exports. ##

import .Legacy:

    @doc, @comment,

    @document, @docstrings,

    @doc_str, @doc_mstr, @file_str,

    meta

export

    @doc, @comment,

    @document, @docstrings,

    @doc_str, @doc_mstr, @file_str,

    meta,

    Interface

end
