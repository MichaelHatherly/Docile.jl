module Cache

["Caching of docstrings and package metadata."]

export getraw, getparsed, getmeta, addmeta, clear!, objects

using Compat; import Compat.String

import ..Utilities
import ..Collector: Collector, PackageData, ModuleData
import ..Formats

include("types.jl")
include("utilities.jl")
include("storage.jl")
include("interface.jl")

end
