## Re-exports. ##

export

    AbstractEntry,
    Docs,
    Entry,
    Manual,
    Metadata,
    Page

## Module. ##

export documented, isdocumented, metadata

"""
Storage for deprecated ``Metadata`` documentation.

!!set(state:deprecated)
"""
const DOCUMENTED = ObjectIdDict()

"""
Returns the modules that are currently documented by Docile.
"""
documented() = Cache.loadedmodules()

"""
Is the module ``mod`` documented by Docile?
"""
isdocumented(mod::Module) = mod in documented()

"""
Get the ``Metadata`` object associated with a module ``mod``.

!!set(status:deprecated)
"""
function metadata(mod::Module; rebuild = false)
    if isdocumented(mod) && !haskey(DOCUMENTED, mod)
        DOCUMENTED[mod] = Metadata(mod)
    end
    DOCUMENTED[mod]
end

## Metadata. ##

export modulename, manual, entries, root, files, isloaded, isexported

"""
The ``Module`` that a ``Metadata`` object documents.

!!set(status:deprecated)
"""
modulename(meta::Metadata) = meta.modname

"""
The manual files for a ``Metadata`` object ``meta``.

!!set(status:deprecated)
"""
manual(meta::Metadata) = meta.data[:manual]

"""
``ObjectIdDict`` containing documented objects and their associated ``Entry``s.

!!set(status:deprecated)
"""
entries(meta::Metadata) = meta.entries

"""
The rootfile of the module documented by a ``Metadata`` object ``meta``.

!!set(status:deprecated)
"""
root(meta::Metadata) = meta.root

"""
List of all ``include``d files in a module documented by ``Metadata`` object ``meta``.

!!set(status:deprecated)
"""
files(meta::Metadata) = meta.files

"""
Have the docstrings contained in a module been collected yet?

!!set(status:deprecated)
"""
isloaded(meta::Metadata) = meta.loaded

"""
The ``Dict{Symbol, Any}`` containing arbitrary additional data about a ``Metadata`` object.

!!set(status:deprecated)
"""
metadata(meta::Metadata) = meta.data

"""
Is the documented object ``object`` been exported from the given module ``modname``?
"""
function isexported(modname::Module, object)
    meta = metadata(modname)
    data = metadata(meta)

    ent = entries(meta)[object]
    cat = category(ent)

    sym = cat == :macro ? macroname(ent) : name(object)

    sym in data[:exports]
end

isexported(modname::Module, comment::Comment) = false

macroname(ent) = symbol(string("@", metadata(ent)[:signature].args[1]))

name(f::Function) = methods(f).name
name(m::Method)   = Utilities.lsdfield(m, :name)
name(m::Module)   = module_name(m)
name(t::DataType) = t.name.name
name(s::Symbol)   = s
name(s::AbstractString) = s

"""
Get the ``Symbol`` representing an object such as ``Function`` or ``Method``.
"""
name

## Entry. ##

export category, modulename, metadata, docs

"""
What category does an ``Entry`` object belong to?

!!set(status:deprecated)
"""
category{C}(::Entry{C}) = C

"""
Which module does the ``Entry`` object come from?

!!set(status:deprecated)
"""
modulename(e::Entry) = e.modname

"""
Arbitrary additional metadata associated with a particular ``Entry`` ``e``.

!!set(status:deprecated)
"""
metadata(e::Entry) = e.data

"""
The ``Docs`` object for an ``Entry`` object ``e``.

!!set(status:deprecated)
"""
docs(e::Entry) = e.docs

## Docs. ##

export data, format, parsed, parsedocs

"""
Raw docstring associated with a ``Docs`` object ``d``.

!!set(status:deprecated)
"""
data(d::Docs) = d.data

"""
The format that a docstring is written in.

!!set(status:deprecated)
"""
format{F}(d::Docs{F}) = F

"""
Get the parsed docstring for a ``Docs`` object ``d``.

!!set(status:deprecated)
"""
parsed(d::Docs) = isdefined(d, :obj) ? d.obj : (d.obj = parsedocs(d);)

parsedocs{ext}(d::Docs{ext}) = error("Unknown documentation format: $(ext)")

parsedocs(d::Docs{:txt}) = data(d)

"""
Parsing hook for specifying how to parse raw docstrings into formatted text.
"""
parsedocs

## Deprecated. ##

export documentation

"""
The ``Metadata`` object associated with a module ``mod``.

!!set(status:deprecated)
"""
documentation(mod::Module) = metadata(mod)
