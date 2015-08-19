"""
    Doctests
"""
module Doctests

using ..Utilities

import Base.Docs: TypeDoc, FuncDoc
import Base.Markdown: MD, Code

export doctest, details

include("tester.jl")
include("display.jl")

end
