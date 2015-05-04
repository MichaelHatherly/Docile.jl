["Global documentation caches and their associated getters and setters."]

"""
Macro to make a function definition global. Used in `let`-blocks.
"""
macro (+)(expr)
    name = expr.args[1].args[1]
    quote
        global $(esc(name))
        $(esc(expr))
    end
end

let
    const PACK = ObjectIdDict() # Module => PackageData
    const MODS = ObjectIdDict() # Module => ModuleData

    "Has the module `m` been registered with Docile."
    @+ hasmodule(m::Module) = haskey(MODS, m)

    "Get the `ModuleData` object associated with a module `m`."
    @+ function getmodule(m::Module)
        hasmodule(m) && return MODS[m]::ModuleData
        p = m
        while p != Main
            if haspackage(p)
                getpackage(p)
                return MODS[m]::ModuleData
            end
            p = module_parent(p)
        end
        throw(ArgumentError("No module '$(m)' currently cached."))
    end

    "Has the package with root module `m` been registered with Docile?"
    @+ haspackage(m::Module) = haskey(PACK, m)

    "Return the `PackageData` object that represents a registered package."
    @+ function getpackage(m::Module)
        while m != Main
            if haspackage(m)
                # Collect package data if not cached yet.
                if !isa(PACK[m], PackageData)
                    modulename, rootfile, args = PACK[m]
                    setpackage!(m, Collector.PackageData(modulename, rootfile; args...))
                end
                return PACK[m]::PackageData
            end
            m = module_parent(m)
        end
        throw(ArgumentError("'$(m)' is not a cached package."))
    end

    "Register a package with Docile to allow for docstring parsing."
    @+ function setpackage!(m::Module, p::PackageData)
        (haspackage(m) && isa(PACK[m], PackageData)) && warn("Overwriting package '$(m)'.")
        for (mod, data) in p.modules
            MODS[mod] = data
        end
        PACK[m] = p
    end

    "Lazy cache package by storing the module, rootfile, and args instead of a `PackageData`."
    @+ setpackage!(m::Module, lazy) = PACK[m] = lazy
end

"""
Register a package with Docile.

**Note:** Initially just the module, rootfile and args are stored.

Only when documentation is requested for a package is that package parsed and
cached properly. This means registering packages does not impact load times
significantly.

Example:

    Docile.Cache.register!(
        Docile,
        Pkg.dir("Docile", "src", "Docile.jl");
        format = Docile.Formats.PlaintextFormatter
    )

"""
function register!(modulename::Module, rootfile::AbstractString; args...)
    isfile(rootfile) || throw(ArgumentError("Cannot find file '$(rootfile)'."))
    setpackage!(modulename, (modulename, rootfile, args))
    info("Registered package '$(modulename)'.")
end

let
    const DOCS = ObjectIdDict() # Module => DocsCache

    """
    Has the module `m` had it's documentation extracted with `Docile.Collector.docstrings`?
    """
    @+ hasdocs(m::Module) = haskey(DOCS, m)

    """
    Initialise the documentation cache for a module. Called automatically when getting docs.
    """
    @+ function initdocs!(m::Module)
        package = getpackage(m)
        info("Initialising cache for '$(package.rootmodule)' and related modules...")
        for (mod, data) in package.modules
            print(" $(mod) ")
            raw, meta = Collector.docstrings(data)
            DOCS[mod] = DocsCache(raw, meta)
            println("✓")
        end
        info("Succcessfully initialised package cache.")
    end

    """
    List of all documented modules currently stored by Docile.
    """
    @+ modules() = collect(keys(DOCS))

    """
    Return documentation cache of a module `m`. Initialise an empty cache if needed.
    """
    @+ function getdocs(m::Module)
        hasdocs(m) || initdocs!(m)
        DOCS[m]::DocsCache
    end

    """
    Empty all cached docstrings, parsed docs, and metadata from module `m`'s cache.
    """
    @+ function cleardocs!(m::Module)
        hasdocs(m) || throw(ArgumentError("'$(m)' is not a documented module."))
        empty!(DOCS[m])
        nothing
    end
end


"""
Return a reference to the raw docstring storage for a given module `m`.
"""
getraw(m::Module) = getdocs(m).raw

"""
Return the raw docstring for a given `obj` in the module `m`.
"""
function getraw(m::Module, obj)
    raw = getraw(m)
    haskey(raw, obj) || throw(ArgumentError("'$(obj)' not found in '$(m)'."))
    raw[obj]
end


"""
Return a reference to the parsed docstring cache for a given module `m`.
"""
getparsed(m::Module) = getdocs(m).parsed

"""
Return the parsed form of a docstring for object `obj` in module `m`.

When the parsed docstring has never been accessed before, it is parsed using the
user-definable `Docile.Formats.parsedocs` method.
"""
function getparsed(m::Module, obj)
    parsed = getparsed(m)
    if !haskey(parsed, obj)
        raw         = getraw(m, obj)
        format      = findmeta(m, obj, :format)
        parsed[obj] = Formats.parsedocs(Formats.Format{format}(), raw, m, obj)
    end
    parsed[obj]
end

"""
Run the parser `Docile.Formats.parsedocs` over all raw docstrings in module `m`.

Store the resulting parsed docstrings in the parsed cache for the module.
"""
function parse!(m::Module)
    parsed = getparsed(m)
    for (obj, str) in getraw(m)
        format      = findmeta(m, obj, :format)
        parsed[obj] = Formats.parsedocs(Formats.Format{format}(), str, m, obj)
    end
end


"""
Return a reference to the metadata cache for a given module `m`.
"""
getmeta(m::Module) = getdocs(m).meta

"""
Return the metadata `Dict` for a given object `obj` found in module `m`.
"""
function getmeta(m::Module, obj)
    meta = getmeta(m)
    haskey(meta, obj) || throw(ArgumentError("'$(obj)' not found."))
    meta[obj]::Dict{Symbol, Any}
end

"""
List of all documented objects in a module `m`.
"""
objects(m::Module) = collect(keys(getraw(m)))
