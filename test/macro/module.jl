module MacroDocs

using Docile, Compat
@docstrings(manual = ["../../doc/manual.md"])

include("subfiles/macro-spec.jl")

include("subfiles/functions.jl")
include("subfiles/globals.jl")
include("subfiles/loop-eval.jl")
include("subfiles/macros.jl")
include("subfiles/types.jl")

end
