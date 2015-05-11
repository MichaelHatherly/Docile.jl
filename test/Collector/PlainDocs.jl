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

include(joinpath("PlainDocs", "functions.jl"))
include(joinpath("PlainDocs", "globals.jl"))
include(joinpath("PlainDocs", "macros.jl"))
include(joinpath("PlainDocs", "types.jl"))

"f_0/0"
f_0() = ()

module Inner_Module()

""
f_0() = ()

end

end
