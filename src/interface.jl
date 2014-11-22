module Interface

import Docile: Documentation, Manual, Page, Entry, Docs, METADATA

export Documentation, Manual, Page, Entry, Docs

export documentation, isdocumented, documented, modulename, manual, entries,
       metadata, pages, docs, file, category, parsed, parsedocs, data

using Docile
@docstrings(manual = ["../doc/interface.md"])

# Documentation
@doc "`Documentation` object stored in a module. Error raised if not documented." ->
documentation(m::Module) = isdocumented(m) ? getfield(m, METADATA) : error("$(m) not documented.")

@doc "Returns the modules that are currently documented by Docile." ->
documented() = Docile.__DOCUMENTED_MODULES__

@doc "Check whether a module has been documented using Docile.jl." ->
isdocumented(m::Module) = m ∈ documented()

@doc "Module where the `Documentation` object is defined." ->
modulename(d::Documentation) = d.modname

@doc "The `Manual` object containing a module's manual pages." ->
manual(d::Documentation) = d.manual

@doc "Dictionary associating objects and documentation entries." ->
entries(d::Documentation) = d.entries

@doc "The metadata dictionary containing configuration settings." ->
metadata(d::Documentation) = d.meta

# Manual
@doc "List of pages that provide general documentation related to a module." ->
pages(m::Manual) = m.pages

# Page
@doc "The documentation stored in a manual page." ->
docs(p::Page) = p.docs

@doc "File where a page's content was read from." ->
file(p::Page) = p.file

# Entry
@doc "Symbol representing the category that an `Entry` belongs to." ->
category{K}(e::Entry{K}) = K

@doc "Module where the entry is defined." ->
modulename(e::Entry) = e.modname

@doc "Dictionary containing arbitrary metadata related to an entry." ->
metadata(e::Entry) = e.meta

@doc "Documentation related to the entry." ->
docs(e::Entry) = e.docs

# Docs
@doc "The raw content stored in a docstring." ->
data(d::Docs) = d.data

@doc "The parsed documentation for an object. Lazy parsing." ->
parsed(d::Docs) = isdefined(d, :obj) ? d.obj : (d.obj = parsedocs(d);)

@doc """
Extension method for handling arbitrary docstring formats.

Parsers for additional formats can be defined by extending this method as follows:

```julia
import Docile.Interface: parsedocs

parsedocs(d::Docs{:format}) = Format.parse(data(d))

```

where `:format` is the symbol representing the docstring's format and `Format.parse` is
the desired parser.
""" ->
parsedocs{ext}(d::Docs{ext}) = error("Unknown documentation format: $(ext)")

parsedocs(d::Docs{:txt}) = data(d)

end
