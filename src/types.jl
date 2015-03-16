type File
    path::AbstractString
end

immutable Comment
    id::Symbol
    Comment() = new(gensym("comment"))
end

"""
Lazy-loading documentation object. Initially the raw documentation string is
stored in `data` while `obj` field remains undefined. The parsed documentation
AST/object/etc. is cached in `obj` on first request for it. `format` is a
symbol.
"""
type Docs{format}
    data :: AbstractString
    obj

    "Lazy `obj` field access which leaves the `obj` field undefined until first accessed."
    Docs(data::AbstractString) = new(data)

    "Pass `Doc` objects straight through. Simplifies code in `Entry` constructors."
    Docs(docs::Docs) = docs

    "Read a file's contents as the docstring."
    Docs(file::File) =
        isfile(file.path) ?
        new(readall(file.path)) :
        new("Missing file: $(file.path)")
end

"Guess doc format from file extension. Entry docstring created when file does not exist."
function externaldocs(mod, meta)
    file = abspath(joinpath(getdoc(mod).data[:root]), get(meta, :file, ""))
    isfile(file) ? readdocs(file) : Docs{getdoc(mod).data[:format]}("")
end

"Load and apply format based on extension to the given `filename`."
readdocs(file) = Docs{format(file)}(readall(file))

"Extract the format of a file based *solely* of the file's extension."
format(file) = symbol(splitext(file)[end][2:end])

abstract AbstractEntry

"""
Type representing a docstring and associated metadata in the
module's `Documentation` object.

The `Docile.Interface` module (documentation available
[here](interface.html)) provides methods for working with `Entry`
objects.
"""
type Entry{category} <: AbstractEntry # category::Symbol
    docs    :: Docs
    data    :: Dict{Symbol, Any}
    modname :: Module

    "Handle the `meta` method syntax for `@doc`."
    function Entry(modname::Module, source, tup::Tuple)
        doc, data = tup
        data[:source] = source

        # When a `file` field is provided in the metadata override the given docstring and
        # instead use the file's contents.
        d = haskey(data, :file) ?
            externaldocs(modname, data) :
            Docs{getdoc(modname).data[:format]}(doc)

        new(d, data, modname)
    end

    "Convenience constructor for simple string docs."
    function Entry(modname::Module, source, doc::AbstractString)
        data = Dict{Symbol, Any}()
        data[:source] = source
        new(Docs{getdoc(modname).data[:format]}(doc), data, modname)
    end

    "For md\"\" etc. -style docstrings."
    function Entry(modname::Module, source, doc::Docs)
        data = Dict{Symbol, Any}()
        data[:source] = source
        new(doc, data, modname)
    end

    Entry(args...) = error("@doc: incorrect arguments given to macro:\n$(args)")
end

## Manual Pages. ------------------------------------------------------------------------

type Page
    docs :: Docs
    file :: AbstractString

    Page(file) = new(readdocs(file), file)
end

type Manual
    pages :: Vector{Page}

    Manual(root, files) = new([Page(abspath(joinpath(root, file))) for file in files])
end

"Usage from REPL, use current directory as root."
Manual(::Nothing, files) = Manual(pwd(), files)

## Additional Metadata constructors. ----------------------------------------------------

function Metadata(modname::Module, file, data::Dict = Dict())
    register!(modname)

    default = @compat Dict{Symbol, Any}(
        :manual => AbstractString[],
        :format => :md
        )
    data   = merge(default, data)
    root   = data[:root] = dirname(file)
    manual = Manual(root, data[:manual])

    Metadata(modname, ObjectIdDict(), root, Set{UTF8String}(), data, true)
end
Metadata(m::Module, ::Nothing, data = Dict()) = Metadata(m, joinpath(pwd(), "_"), data)

## Metadata accessors. ------------------------------------------------------------------

"Warn the author about overwritten metadata."
function pushmeta!(doc::Metadata, object, entry::Entry)
    if haskey(doc.entries, object)
        warn("Overwriting metadata for `$(doc.modname).$(object)`.")
    end
    doc.entries[object] = entry
    nothing # `setmeta!` doesn't return anything.
end

"Metatdata interface for *single* objects. `args` is the docstring and metadata dict."
function setmeta!(modname, object, category, source, args...)
    entry = Entry{category}(modname, source, args...)
    # translate symbolic macro names into their underlying functions.
    if category ≡ :macro
        entry.data[:signature] = object
        object = getfield(modname, macroname(object.args[1]))
    end
    pushmeta!(getdoc(modname), object, entry)
end

"""
For varargs method definitions since they generate multiple method objects. Use
the *same* Entry object for each object's documentation.
"""
function setmeta!(modname, objects::Set, category, source, args...)
    entry = Entry{category}(modname, source, args...)
    meta = getdoc(modname)
    for object in objects
        pushmeta!(meta, object, entry)
    end
end

"Return the Metadata object stored in a module."
function getdoc(modname)
    isdefined(modname, METADATA) || error("No metadata defined in module $(modname).")
    getfield(modname, METADATA)
end

## Metadata utilities. ------------------------------------------------------------------

function (==)(a::Metadata, b::Metadata)
    all([getfield(a, f) == getfield(b, f) for f in fieldnames(Metadata)])
end

function copy(m::Metadata)
    Metadata(m.modname, copy(m.entries), m.root,
             copy(m.files), copy(m.data), m.loaded)
end
