module Interface

using Compat; import Compat.String

import ..Legacy:

    AbstractEntry,
    Comment,
    Docs,
    Entry,
    Manual,
    Metadata,
    Page

import ..Utilities: Utilities
import ..Cache
import ..Formats

include("legacy.jl")

end
