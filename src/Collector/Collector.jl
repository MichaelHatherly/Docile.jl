module Collector

using Compat; import Compat.String

import ..Utilities:

    Utilities,
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
    pushscope!,
    popscope!

import ..Formats

include("utilities.jl")
include("search.jl")
include("types.jl")
include("docstrings.jl")

end
