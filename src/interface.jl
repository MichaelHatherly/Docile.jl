module Interface

import Docile: Entry, Manual, Documentation, Docstring, METADATA

export Entry, Manual, Documentation,
       category, docs, metadata,
       modulename, manual, pages, entries,
       documentation, isdocumented

using Docile
@docstrings [ :manual => ["../doc/interface.md"] ]

@doc "Symbol representing the category that an `Entry` belongs to." ->
category{K}(entry::Entry{K}) = K

@doc "Raw documentation string associated with an `Entry`." ->
docs(entry::Entry) = entry.docs.content

@doc "Dictionary containing all metadata associated with an `Entry`." ->
metadata(entry::Entry) = entry.meta

@doc "Module that a `Documentation` object documents." ->
modulename(doc::Documentation) = doc.modname

@doc "The `Manual` object containing a module's manual pages." ->
manual(doc::Documentation) = doc.manual

@doc "Vector containing the contents of each manual page and file name." ->
pages(manual::Manual) = [(file, page.content) for (file, page) in manual.pages]

@doc "Dictionary associating objects and documentation entries." ->
entries(doc::Documentation) = doc.entries

@doc "Check whether a module has been documented using Docile.jl." ->
isdocumented(modulename::Module) = isdefined(modulename, METADATA)

@doc """
The `Documentation` object in a documented module. This method raises an
error if the module is not documented.
""" ->
function documentation(modulename::Module)
    if isdocumented(modulename)
        getfield(modulename, METADATA)
    else
        error("$(modulename) is not documented.")
    end
end

end
