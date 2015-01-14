module Skipped_Outer_Module

""
f_1() = ()

end

module PlainDocs

reload("Docile.jl")

using Docile, Compat
@document(manual = ["../../doc/manual.md"])

# For testing `Docile.Interface.isexported` functionality.
export f_2, T_A_2, T_TA_2, G_M_2, @m_2

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
