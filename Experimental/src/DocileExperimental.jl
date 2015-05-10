module DocileExperimental

include("Utilities.jl")             # Code useful across submodules.

include("Formats/Formats.jl")       # Format-dispatch for parsing docstrings.

include("Runner/Runner.jl")         # Execute expressions.
include("Collector/Collector.jl")   # Collect information from modules.

include("Cache/Cache.jl")           # Store collected information.

include("Legacy/Legacy.jl")         # Compatibilty with base and docile.
include("Interface/Interface.jl")   # Public interface to the package.

include("Extensions/Extensions.jl") # Additional formatters and parsers.

## Direct Exports. ##

import .Legacy:

    @doc,

    @document, @docstrings,

    @doc_str, @doc_mstr, @file_str,

    meta

export

    @doc,

    @document, @docstrings,

    @doc_str, @doc_mstr, @file_str,

    meta,

    Interface

end
