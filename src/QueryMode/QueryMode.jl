module QueryMode

using ..Utilities, Base.Meta

include("utilities.jl")
include("types.jl")
include("builder.jl")
include("exec.jl")

include("debug.jl")

include("repl.jl")

# Don't depend of Mux just yet. Optional extra at the moment.
Pkg.installed("Mux") == nothing || include("webserver.jl")

__init__() = initmode()

end
