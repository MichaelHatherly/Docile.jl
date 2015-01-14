module Interface

using Docile
@document(manual = ["../doc/interface.md"])

## Imports. -----------------------------------------------------------------------------

import Docile:

    Metadata,
    Manual,
    Page,
    AbstractEntry,
    Entry,
    Docs,
    METADATA,
    builddocs!

## Re-exports. --------------------------------------------------------------------------

const Documentation = Metadata # Backwards compatibility.

export

    Documentation,
    Metadata,
    Manual,
    Page,
    AbstractEntry,
    Entry,
    Docs

## Module. ------------------------------------------------------------------------------

export documented, isdocumented, metadata

"""
Returns the modules that are currently documented by Docile.
"""
documented() = Docile.DOCUMENTED

"""
Is the given module `modname` documented using Docile?
"""
isdocumented(mod::Module) = mod ∈ documented()

"""
Returns the `Metadata` object stored in a module `modname` by Docile.

Throws an `ArgumentError` when the module has not been documented.

If the `Metadata` is not loaded yet (`isloaded` returns `false`) then that is
done first, and the resulting documentation is returned.
"""
function metadata(mod::Module; rebuild = false)
    isdocumented(mod) || throw(ArgumentError("$(mod) is not documented."))
    meta = getfield(mod, METADATA)
    # We only need to build the module's documentation if it's not been done
    # yet, or if explicitly asked to do so by `rebuild = true`.
    if !isloaded(meta) || rebuild
        info("Parsing documentation for $(mod).")
        builddocs!(meta)
        meta.loaded = true
    end
    meta
end

## Metadata. ----------------------------------------------------------------------------

export modulename, manual, entries, root, files, isloaded, isexported

"""
Module where the `Metadata` object is defined.
"""
modulename(meta::Metadata) = meta.modname

"""
The `Manual` object containing a module's manual pages.
"""
manual(meta::Metadata) = meta.data[:manual]

"""
Dictionary associating objects and documentation entries.
"""
entries(meta::Metadata) = meta.entries

"""
File containing the module definition documented with the `meta` object.
"""
root(meta::Metadata)  = meta.root

"""
All files `include`d in the module documented with the `meta` object.
"""
files(meta::Metadata) = meta.files

"""
Has the documentation contained in a module been loaded into the `meta` object?
"""
isloaded(meta::Metadata) = meta.loaded

"""
A dictionary containing configuration settings related to the `meta` object.
"""
metadata(meta::Metadata) = meta.data

"""
Check whether `object` has been exported from a *documented* module `modname`.
"""
function isexported(modname::Module, object)

    meta = metadata(modname)
    data = metadata(meta)

    # Don't recalculate exports every time.
    if !haskey(data, :exports)
        data[:exports] = Set{Symbol}(names(modulename(meta)))
    end

    ent = entries(meta)[object]
    cat = category(ent)

    # Special case macros since they're stored as anon funcs.
    sym = cat == :macro ? macroname(ent) : name(object)

    sym ∈ data[:exports]
end

macroname(ent) = symbol(string("@", metadata(ent)[:signature].args[1]))

name(f::Function) = f.env.name
name(m::Method)   = m.func.code.name
name(t::DataType) = t.name.name
name(s::Symbol)   = s

## Entry. -------------------------------------------------------------------------------

export category, modulename, metadata, docs

"""
Symbol representing the category that an `Entry` belongs to.
"""
category{C}(e::Entry{C}) = C

"""
Module where the entry is defined.
"""
modulename(e::Entry) = e.modname

"""
Dictionary containing arbitrary metadata related to an entry.
"""
metadata(e::Entry) = e.data

"""
Documentation related to the entry.
"""
docs(e::Entry) = e.docs

## Docs. --------------------------------------------------------------------------------

export data, format, parsed, parsedocs

"""
The raw content stored in a docstring.
"""
data(d::Docs) = d.data

"""
Return the format that a docstring is written in.
"""
format{F}(d::Docs{F}) = F

"""
The parsed documentation for an object. Lazy parsing.
"""
parsed(d::Docs) = isdefined(d, :obj) ? d.obj : (d.obj = parsedocs(d);)

"""
Extension method for handling arbitrary docstring formats.

Parsers for additional formats can be defined by extending this method as follows:

```julia
import Docile.Interface: parsedocs

parsedocs(d::Docs{:format}) = Format.parse(data(d))

```

where `:format` is the symbol representing the docstring's format and `Format.parse` is
the desired parser.
"""
parsedocs{ext}(d::Docs{ext}) = error("Unknown documentation format: $(ext)")

parsedocs(d::Docs{:txt}) = data(d)

## Deprecated. --------------------------------------------------------------------------

export documentation

documentation(mod::Module) = metadata(mod)

end
