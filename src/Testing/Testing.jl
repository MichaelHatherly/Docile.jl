"""
    Doctests

Test Julia code blocks found in docstrings.

**Module Exports:**

$(Utilities.exportlist(Testing))
"""
module Testing

using ..Utilities

import Base.Docs: TypeDoc, FuncDoc
import Base.Markdown: MD, Code

include("doctest.jl")
include("display.jl")

end
