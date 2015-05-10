module MacroDocs

if VERSION < v"0.4-dev+4319"
    tup(args...) = tuple(args...)
else
    tup(args...) = Tuple{args...}
end

import Docile: @doc, @docstrings, @doc_str, @doc_mstr, meta

@docstrings(manual = ["../../docs/manual.md"])

include("MacroDocs/macro-spec.jl")

include("MacroDocs/functions.jl")
include("MacroDocs/globals.jl")
include("MacroDocs/macros.jl")
include("MacroDocs/types.jl")

end
