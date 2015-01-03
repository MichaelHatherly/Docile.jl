module Skipped_Outer_Module

""
f_1() = ()

end

module PlainDocs

reload("Docile.jl")

using Docile, Compat
@document(manual = ["../../doc/manual.md"])

include("subfiles/functions.jl")
include("subfiles/globals.jl")
include("subfiles/loop-eval.jl")
include("subfiles/macros.jl")
include("subfiles/types.jl")

module Skipped_Inner_Module

""
f_1() = ()

end

end
