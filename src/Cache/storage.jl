["Global documentation caches and their associated getters and setters."]

"""
Macro to make a function definition global. Used in ``let``-blocks.
"""
macro (+)(expr)
    name = expr.args[1].args[1]
    quote
        global $(esc(name))
        $(esc(expr))
    end
end


let
    const INCLUDE_BASE = [false]

    """
    !!summary(Switch on/off documenting of ``Base`` and it's submodules.)

    **Note:** This is an experimental feature and so is initially disabled.
    """
    @+ togglebase() = INCLUDE_BASE[1] = !INCLUDE_BASE[1]


    const LOADED = Set{UTF8String}()

    # Diff the loaded packages with the packages that have been imported into
    # Julia. Cache all newly added packages.
    function update!()
        diff   = Set{UTF8String}()
        loaded = Set{UTF8String}(keys(Base.package_list))
        # Do we want to include ``Base`` in the list?
        INCLUDE_BASE[1] && push!(loaded, Utilities.expandpath("sysimg.jl"))
        # Find newly added packages.
        if length(loaded) > length(LOADED)
            Utilities.message("updating package list…")
            diff = setdiff(loaded, LOADED)
            # Update the current package stats.
            LOADED = loaded
        end
        for (rootmodule, package) in Collector.findpackages(diff)
            setpackage!(rootmodule, package)
        end
    end


    const PACK = ObjectIdDict() # Module => PackageData
    const MODS = ObjectIdDict() # Module => ModuleData

    @+ loadedmodules() = (update!(); Set{Module}(keys(MODS)))

    """
    Has the module ``m`` been registered with Docile.

    When module isn't found then check for newly added packages first.
    """
    @+ hasmodule(m::Module) = haskey(MODS, m) ? true : (update!(); haskey(MODS, m))

    """
    Get the ``ModuleData`` object associated with a module ``m``.
    """
    @+ function getmodule(m::Module)
        hasmodule(m) && return MODS[m]::ModuleData
        p = m
        while p != Main
            haspackage(p) && return MODS[m]::ModuleData
            p = module_parent(p)
        end
        throw(ArgumentError("No module '$(m)' currently cached."))
    end

    """
    Has the package with root module ``m`` been registered with Docile?

    When package isn't found then check for newly added packages first.
    """
    @+ haspackage(m::Module) = haskey(PACK, m) ? true : (update!(); haskey(PACK, m))

    """
    Return the ``PackageData`` object that represents a registered package.
    """
    @+ function getpackage(m::Module)
        mod = m
        while m != Main
            haspackage(m) && return PACK[m]::PackageData
            m = module_parent(m)
        end
        throw(ArgumentError("'$(mod)' is not a cached package."))
    end

    function setpackage!(m::Module, p::PackageData)
        haspackage(m) && warn("Overwriting package '$(m)'.")
        for (mod, data) in p.modules
            MODS[mod] = data
        end
        PACK[m] = p
    end

    """
    Empty all loaded packages and modules from cache.
    """
    @+ clearpackages!() = (map(empty!, (LOADED, PACK, MODS)); nothing)
end

let
    const PARSED = Set{Module}()

    """
    Has module ``m`` been parsed yet?
    """
    @+ hasparsed(m::Module) = m ∈ PARSED

    """
    Module ``m`` has had it's docstrings parsed.
    """
    @+ setparsed(m::Module) = push!(PARSED, m)


    const DOCS = ObjectIdDict() # Module => DocsCache

    # Initialise documentation cache for module. Called automatically when getting docs.
    function initdocs!(m::Module)
        package  = getpackage(m)
        maxwidth = longest_module(package)
        Utilities.message("caching '$(package.rootmodule)'…")
        for (mod, data) in package.modules
            print(" - $(mod) ", padding(maxwidth, mod))
            raw, meta = Collector.docstrings(data)
            DOCS[mod] = DocsCache(raw, meta)
            println("✓")
        end
    end
    longest_module(pack) = maximum([length(string(mod)) for (mod, data) in pack.modules])
    padding(width, mod)  = " "^(width - length(string(mod)))

    """
    List of all documented modules currently stored by Docile.
    """
    @+ modules() = collect(keys(DOCS))

    """
    Has module ``m`` had documentation extracted with ``Docile.Collector.docstrings``?
    """
    @+ hasdocs(m::Module) = haskey(DOCS, m)

    """
    Return documentation cache of a module ``m``. Initialise an empty cache if needed.
    """
    @+ function getdocs(m::Module)
        hasdocs(m) || initdocs!(m)
        DOCS[m]::DocsCache
    end

    """
    Empty cached docstrings, parsed docs, and metadata from all modules.
    """
    @+ cleardocs!() = (empty!(DOCS); empty!(PARSED); nothing)
end

## Raw docstrings. ##

"""
Return a reference to the raw docstring storage for a given module ``m``.
"""
getraw(m::Module) = getdocs(m).raw

"""
Return the raw docstring for a given ``obj`` in the module ``m``.
"""
function getraw(m::Module, obj)
    raw = getraw(m)
    haskey(raw, obj) || throw(ArgumentError("'$(obj)' not found in '$(m)'."))
    raw[obj]
end

## Parsed docstrings. ##

"""
Return a reference to the parsed docstring cache for a given module ``m``.
"""
getparsed(m::Module) = (parse!(m); getdocs(m).parsed)

"""
Return the parsed form of a docstring for object ``obj`` in module ``m``.

When the parsed docstring has never been accessed before, it is parsed using the
user-definable ``Docile.Formats.parsedocs`` method.
"""
function getparsed(m::Module, obj)
    parsed = getparsed(m)
    haskey(parsed, obj) || throw(ArgumentError("'$(obj)' not found."))
    parsed[obj]
end

## Metadata. ##

"""
Return metadata ``Dict`` stored in ``ModuleData`` and ``PackageData`` objects.

Example:

    import Docile.Cache

    package_data = Cache.getpackage(Docile)
    module_data  = Cache.getmodule(Docile.Formats)

    Cache.getmeta(package_data)
    Cache.getmeta(module_data)

"""
getmeta(obj::Union(ModuleData, PackageData)) = obj.metadata

"""
Return reference to object metadata cache for module ``m``.
"""
getmeta(m::Module) = (parse!(m); getdocs(m).meta)

"""
Return metadata ``Dict`` for object ``obj`` found in module ``m``.
"""
function getmeta(m::Module, obj)
    meta = getmeta(m)
    haskey(meta, obj) || throw(ArgumentError("'$(obj)' not found."))
    meta[obj]::Dict{Symbol, Any}
end

"""
Adds new metadata key ``k`` with value ``v`` for object ``obj`` found in module ``m``.
"""
function addmeta(m::Module, obj, k::Symbol, v)
    meta = getmeta(m, obj)
    haskey(meta, k) && throw(ArgumentError("'$(obj)' metada has already a key '$(k)'."))
    meta[k] = v
end

## Misc. ##

"""
Remove all cached objects, modules and packages from storage.
"""
clear!() = (clearpackages!(); cleardocs!())

"""
List of all documented objects in a module ``m``.
"""
objects(m::Module) = collect(keys(getraw(m)))
