module Cache

["Caching of docstrings and package metadata."]

using Compat

import ..Utilities
import ..Collector: Collector, PackageData, ModuleData
import ..Formats

include("utilities.jl")
include("types.jl")
include("storage.jl")

end
