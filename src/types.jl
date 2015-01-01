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
end

"Guess doc format from file extension. Entry docstring created when file does not exist."
function externaldocs(mod, meta)
    file = abspath(joinpath(getdoc(mod).meta[:root]), get(meta, :file, ""))
    isfile(file) ? readdocs(file) : Docs{getdoc(mod).meta[:format]}("")
end

"Load and apply format based on extension to the given `filename`."
readdocs(file) = Docs{format(file)}(readall(file))

"Extract the format of a file based *solely* of the file's extension."
format(file) = symbol(splitext(file)[end][2:end])

"""
Type representing a docstring and associated metadata in the
module's `Documentation` object.

The `Docile.Interface` module (documentation available
[here](interface.html)) provides methods for working with `Entry`
objects.
"""
type Entry{category} # category::Symbol
    docs    :: Docs
    meta    :: Dict{Symbol, Any}
    modname :: Module

    function Entry(modname::Module, source, doc, meta::Dict = Dict())

        # TODO: deprecate
        Base.warn_once("Dict-based syntax for metadata is deprecated. Use `meta` method instead.")

        meta = convert(Dict{Symbol, Any}, meta)
        meta[:source] = source
        new(Docs{getdoc(modname).meta[:format]}(doc), meta, modname)
    end

    # No docstring was provided, try to read from :file. Blank docs field when no file.
    function Entry(modname::Module, source, meta::Dict = Dict())

        # TODO: deprecate
        Base.warn_once("Dict-based syntax for metadata is deprecated. Use `meta` method instead.")

        meta = convert(Dict{Symbol, Any}, meta)
        meta[:source] = source
        new(externaldocs(modname, meta), meta, modname)
    end

    "Handle the `meta` method syntax for `@doc`."
    function Entry(modname::Module, source, tup::Tuple)
        doc, meta = tup
        meta[:source] = source

        # When a `file` field is provided in the metadata override the given docstring and
        # instead use the file's contents.
        d = haskey(meta, :file) ?
            externaldocs(modname, meta) :
            Docs{getdoc(modname).meta[:format]}(doc)

        new(d, meta, modname)
    end

    "Convenience constructor for simple string docs."
    function Entry(modname::Module, source, doc::AbstractString)
        meta = Dict{Symbol, Any}()
        meta[:source] = source
        new(Docs{getdoc(modname).meta[:format]}(doc), meta, modname)
    end

    "For md\"\" etc. -style docstrings."
    function Entry(modname::Module, source, doc::Docs)
        meta = Dict{Symbol, Any}()
        meta[:source] = source
        new(doc, meta, modname)
    end

    Entry(args...) = error("@doc: incorrect arguments given to macro:\n$(args)")
end

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

const DEFAULT_METADATA = @compat Dict{Symbol, Any}(
    :manual => AbstractString[],
    :format => :md
    )

"""
Stores the documentation generated for a module via `@doc`. The instance
created in a module via `@docstrings` is called `__METADATA__`.

The `Docile.Interface` module (documentation available
[here](interface.html)) provides methods for interacting with
`Documentation` objects.
"""
type Documentation
    modname :: Module
    manual  :: Manual
    entries :: ObjectIdDict
    meta    :: Dict{Symbol, Any}

    function Documentation(m::Module, file, meta::Dict = Dict())
        # Track which modules have been documented.
        push!(__DOCUMENTED_MODULES__, m)

        meta = merge(DEFAULT_METADATA, meta)
        meta[:root] = dirname(file)

        new(m, Manual(meta[:root], meta[:manual]), ObjectIdDict(), meta)
    end
end

Documentation(m::Module, ::Nothing, meta = Dict()) = Documentation(m, joinpath(pwd(), "_"), meta)

"Warn the author about overwritten metadata."
function pushmeta!(doc::Documentation, object, entry::Entry)
    haskey(doc.entries, object) && warn("Overwriting metadata for `$(doc.modname).$(object)`.")
    doc.entries[object] = entry
    nothing # `setmeta!` doesn't return anything.
end

"Metatdata interface for *single* objects. `args` is the docstring and metadata dict."
function setmeta!(modname, object, category, source, args...)
    pushmeta!(getdoc(modname), object, Entry{category}(modname, source, args...))
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
