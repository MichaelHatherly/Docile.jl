module QueryMode

using ..Utilities, Base.Meta

include("utilities.jl")
include("types.jl")
include("builder.jl")
include("exec.jl")

include("debug.jl")

include("repl.jl")

__init__() = initmode()

end
