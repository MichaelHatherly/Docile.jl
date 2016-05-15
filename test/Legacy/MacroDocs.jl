module MacroDocs

if VERSION < v"0.4-dev+4319"
    tup(args...) = tuple(args...)
else
    tup(args...) = Tuple{args...}
end

import Docile: @doc, @docstrings, @doc_str, @doc_mstr, meta

using Compat; import Compat.String

@docstrings(manual = ["../../docs/manual.md"])

include(joinpath("MacroDocs", "macro-spec.jl"))

include(joinpath("MacroDocs", "functions.jl"))
include(joinpath("MacroDocs", "globals.jl"))
include(joinpath("MacroDocs", "macros.jl"))
include(joinpath("MacroDocs", "types.jl"))

end
