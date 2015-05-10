module Legacy

using Compat

import ..Utilities: isexpr
import ..Collector
import ..Cache
import ..Formats

include("atdoc.jl")
include("macros.jl")
include("types.jl")

end
