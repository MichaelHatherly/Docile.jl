module Skipped_Outer_Module

""
f_0() = ()

end

module PlainDocs

if VERSION < v"0.4-dev+4319"
    tup(args...) = tuple(args...)
else
    tup(args...) = Tuple{args...}
end

include("PlainDocs/functions.jl")
include("PlainDocs/globals.jl")
include("PlainDocs/macros.jl")
include("PlainDocs/types.jl")

"f_0/0"
f_0() = ()

module Inner_Module()

""
f_0() = ()

end

end
