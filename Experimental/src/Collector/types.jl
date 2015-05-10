["Types, constructures, and display methods related to docstring collection."]

"""
An `Aside` stores a docstring with no direct relation to surrounding objects.

The syntax used to define an `Aside` in source code is as follows:

    [" ... "]

The term "aside" is taken from theater where it is defined as:

>  term used in drama and theater, an aside happens when a character's dialogue
>  is spoken but not heard by the other actors on the stage. Asides are useful
>  for giving the audience special information about the other characters
>  onstage or the action of the plot.
"""
immutable Aside
    file :: UTF8String
    line :: Int
end


"""
Stores the data related to a single `Module` object found in a package.

`include`d files and their associated parsed forms are stored here. Additional
metadata may be stored in a `ModuleData` object.
"""
type ModuleData
    modname  :: Module
    rootfile :: UTF8String
    files    :: Set{UTF8String}
    parsed   :: Dict{UTF8String, Expr}
    metadata :: Dict{Symbol, Any}
end

function Base.writemime(io::IO, mime::MIME"text/plain", md::ModuleData)
    println(io, "ModuleData($(md.modname), $(md.rootfile), ..., ..., ...)")
end


"""
Extract information from a package for documentation perposes.

Example:

    PackageData(Docile, Pkg.dir("Docile", "src", "Docile.jl"))

Given a module reference and root file path we search for all submodules of
module `mod` and each modules' `include`d files.

Parse all the files into expression trees for later docstring extraction.

Keyword arguments are stored as the package's metadata. Any keywords that match
the name of a submodule will be taken as that module's metadata and so must be a
`Dict{Symbol, Any}` object.

**Note:** files that only contain constants will not be found.
"""
type PackageData
    rootmodule :: Module
    rootfile   :: UTF8String
    modules    :: Dict{Module, ModuleData}
    metadata   :: Dict{Symbol, Any}

    # Find files and parse them to avoid duplication below.
    function PackageData(mod::Module, rootfile::AbstractString; kwargs...)
        candidates = matching(dirname(rootfile)) do f
            isfile(f) && endswith(f, ".jl")
        end
        parsed = [file => parsefile(file) for file in candidates]
        PackageData(mod, rootfile, candidates, parsed; kwargs...)
    end

    # Called directly by `findpackages` to avoid reparsing files.
    function PackageData(mod::Module, rootfile::AbstractString, candidates, parsed; kwargs...)

        metadata = Dict(kwargs)
        # Execute the `.docile` file if found and merge it's configuration settings.
        merge!(metadata, getdotfile(dirname(rootfile)))
        # Provide a default formatter if none was specified.
        haskey(metadata, :format) || (metadata[:format] = Formats.PlaintextFormatter)

        mods   = submodules(mod)
        files  = [m => includedfiles(m, candidates) for m in mods]

        roots = Dict{Module, UTF8String}()
        for m in mods
            # Check all the included files for a module expression.
            for file in files[m]
                if isrootfile(module_name(m), parsed[file])
                    roots[m] = file
                    break
                end
            end
            # Last resort. Check every single file.
            if !haskey(roots, m)
                for file in candidates
                    file in files[m] && continue # Skip ones already searched.
                    if isrootfile(module_name(m), parsed[file])
                        roots[m] = file
                        break
                    end
                end
            end
        end

        # Separate each submodule's data from the package's.
        modules = Dict{Module, ModuleData}()
        for m in mods

            # Discard modules that don't have a rootfile.
            haskey(roots, m) || continue

            name = module_name(m)

            mroot   = roots[m]
            mfiles  = files[m]

            mroot in mfiles && pop!(mfiles, mroot)

            mparsed = [file => parsed[file] for file in mfiles]
            mparsed[mroot] = parsed[mroot]

            # Keywords that match found modules are used as the module's metadata
            # and removed from the package's metadata.
            mmeta = haskey(metadata, name) ? pop!(metadata, name) : Dict{Symbol, Any}()

            # Add exports list to each module.
            mmeta[:exports] = Set{Symbol}(names(m))

            modules[m] = ModuleData(m, mroot, mfiles, mparsed, mmeta)
        end

        new(mod, rootfile, modules, metadata)
    end
end

function Base.writemime(io::IO, mime::MIME"text/plain", pd::PackageData)
    println(io, "PackageData($(pd.rootmodule), $(pd.rootfile), ..., ...)")
end
