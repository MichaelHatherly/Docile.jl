"""
# Docile

Documentation extensions for Julia.

The public documentation is available in [public.md](doc/build/public.md), while internals
are documented in [internals.md](doc/build/internals.md).

**Package Exports:**

$(Utilities.exportlist(Docile))
"""
module Docile

include("Utilities.jl")

include(joinpath("Docs",    "Docs.jl"))
include(joinpath("Testing", "Testing.jl"))
include(joinpath("Build",   "Build.jl"))

# Public API.

import .Docs: addhook, directives
export        addhook, directives

import .Testing: doctest, details
export           doctest, details

import .Build: makedocs
export         makedocs

end # module
