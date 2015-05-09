module Interface

using Compat

import ..Legacy:

    AbstractEntry,
    Comment,
    Docs,
    Entry,
    Manual,
    Metadata,
    Page

import ..Cache
import ..Formats

include("legacy.jl")

end
