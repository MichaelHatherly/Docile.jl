module DocileExperimental

include("Utilities.jl")           # Code useful across submodules.

include("Formats/Formats.jl")     # Format-dispatch for parsing docstrings.

include("Runner/Runner.jl")       # Execute expressions.
include("Collector/Collector.jl") # Collect information from modules.

include("Cache/Cache.jl")         # Store collected information.

include("Interface.jl")           # Public interface to the package.

end
