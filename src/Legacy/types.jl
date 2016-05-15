["Backward-compatible types."]

## Comment/Aside. ##

immutable Comment
    id :: Symbol
    Comment() = new(gensym("comment"))
end

## Docs. ##

type Docs{format}
    data :: AbstractString
    obj

    Docs(data) = new(data)
end

## Entries. ##

abstract AbstractEntry

type Entry{category} <: AbstractEntry
    docs    :: Docs
    data    :: Dict{Symbol, Any}
    modname :: Module
end

## Manual pages. ##

readdocs(file) = Docs{format(file)}(readall(file))

format(file) = symbol(splitext(file)[end][2:end])

type Page
    docs :: Docs
    file :: AbstractString

    Page(file) = new(readdocs(file), file)
end

type Manual
    pages :: Vector{Page}

    Manual(root, files) = new([Page(abspath(joinpath(root, file))) for file in files])
end

"Usage from REPL, use current directory as root.";
Manual(::@compat(Void), files) = Manual(pwd(), files)

## Metadata. ##

type Metadata
    modname :: Module
    entries :: ObjectIdDict
    root    :: String
    files   :: Set{String}
    data    :: Dict{Symbol, Any}
    loaded  :: Bool
end

function Metadata(m::Module)

    # Import needed data from actual cache.
    moduledata = Cache.getmodule(m)
    rawdocs    = Cache.getraw(m)
    metadata   = Cache.getmeta(m)

    # `Metadata` fields initialisation.
    modname = m
    entries = ObjectIdDict()
    root    = moduledata.rootfile
    files   = deepcopy(moduledata.files)
    data    = deepcopy(moduledata.metadata)
    loaded  = true

    # Add some default module metadata.
    format = get!(data, :format, :md)
    manual = get!(data, :manual, String[])

    # Populate the `entries` field.
    for (obj, raw) in rawdocs

        # Move the `:codesource` metadata to old `:source` field.
        if haskey(metadata[obj], :codesource)
            metadata[obj][:source] = metadata[obj][:codesource]
            delete!(metadata[obj], :codesource)
        end

        # Match old-style object storage.
        newobj, newcat = reconstruct(obj, metadata)

        # Build the `Entry` object and store it.
        entries[newobj] = Entry{newcat}(
            Docs{format}(Formats.extractmeta!(raw, modname, obj)),
            metadata[obj],
            modname
            )
    end

    Metadata(
        modname,
        entries,
        root,
        files,
        data,
        loaded
        )
end

reconstruct(obj::Collector.Aside, ::Any)              = (Comment(), :comment)
reconstruct(obj::Collector.QualifiedSymbol, metadata) = (obj.sym, metadata[obj][:category])
reconstruct(obj, metadata)                            = (obj, metadata[obj][:category])

function Base.copy(m::Metadata)
    Metadata(m.modname, copy(m.entries), m.root,
             copy(m.files), copy(m.data), m.loaded)
end
