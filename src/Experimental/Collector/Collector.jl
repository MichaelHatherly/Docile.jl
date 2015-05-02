module Collector

using Compat

import ..Utilities:

    isexpr,
    parsefile,
    Head,
    @H_str

import ..Runner:

    State,
    findmethods,
    findtuples,
    findvcats,
    exec,
    getvar,
    typevars,
    pushscope!,
    popscope!

include("utilities.jl")
include("search.jl")
include("types.jl")
include("docstrings.jl")

end
