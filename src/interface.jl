module Interface

import Docile: Entry, Manual, Documentation, METADATA

export Entry, Manual, Documentation,
       category, docs, metadata,
       modulename, manual, pages, entries,
       documentation, isdocumented

using Docile
@docstrings {"../doc/interface.md"}

@doc "Symbol representing the category that an `Entry` belongs to." ->
category{K}(entry::Entry{K}) = K

@doc "The raw documentation associated with an `Entry`." ->
docs(entry::Entry) = entry.docs

@doc "The dictionary containing all metadata associated with an `Entry`." ->
metadata(entry::Entry) = entry.meta

@doc "The module that a `Documentation` object documents." ->
modulename(doc::Documentation) = doc.modname

@doc "The `Manual` object containing a module's manual pages." ->
manual(doc::Documentation) = doc.manual

@doc "Path and contents tuples representing the manual pages in order." ->
pages(manual::Manual) = manual.pages

@doc "A dictionary of associating documentation entries to objects." ->
entries(doc::Documentation) = doc.entries

@doc "Check whether a module has been documented using Docile.jl." ->
isdocumented(modulename::Module) = isdefined(modulename, METADATA)

@doc "The `Documentation` object in a documented module." ->
function documentation(modulename::Module)
    if isdocumented(modulename)
        getfield(modulename, METADATA)
    else
        error("$(modulename) is not documented.")
    end
end

end
