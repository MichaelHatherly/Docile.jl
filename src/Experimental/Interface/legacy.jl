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

const DOCUMENTED = ObjectIdDict()

documented() = Set{Module}(keys(DOCUMENTED))

isdocumented(mod::Module) = mod in documented()

function metadata(mod::Module; rebuild = false)
    isdocumented(mod) || (DOCUMENTED[mod] = Metadata(mod))
    DOCUMENTED[mod]
end

## Metadata. ##

export modulename, manual, entries, root, files, isloaded, isexported

modulename(meta::Metadata) = meta.modname

manual(meta::Metadata) = meta.data[:manual]

entries(meta::Metadata) = meta.entries

root(meta::Metadata) = meta.root

files(meta::Metadata) = meta.files

isloaded(meta::Metadata) = meta.loaded

metadata(meta::Metadata) = meta.data

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

name(f::Function) = f.env.name
name(m::Method)   = m.func.code.name
name(m::Module)   = module_name(m)
name(t::DataType) = t.name.name
name(s::Symbol)   = s

## Entry. ##

export category, modulename, metadata, docs

category{C}(::Entry{C}) = C

modulename(e::Entry) = e.modname

metadata(e::Entry) = e.data

docs(e::Entry) = e.docs

## Docs. ##

export data, format, parsed, parsedocs

data(d::Docs) = d.data

format{F}(d::Docs{F}) = F

parsed(d::Docs) = isdefined(d, :obj) ? d.obj : (d.obj = parsedocs(d);)

parsedocs{ext}(d::Docs{ext}) = error("Unknown documentation format: $(ext)")

parsedocs(d::Docs{:txt}) = data(d)
