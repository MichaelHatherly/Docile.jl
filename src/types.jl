@docref () -> REF_ENTRY
type Entry{category} # category::Symbol
    docs::Docstring
    meta::Dict{Symbol, Any}
    modname::Module

    # handle external docstrings
    function Entry(source, doc::Documentation, meta::Dict)
        push!(meta, :source, source)
        text =
            if haskey(meta, :file)
                formatted(joinpath(dirname(source[2]), meta[:file]))
            else
                doc.meta[:format]("")
            end
        new(text, meta, doc.modname)
    end

    # handle internal raw docstrings
    function Entry(source, doc::Documentation, text::String, meta::Dict = Dict{Symbol, Any}())
        push!(meta, :source, source)
        new(doc.meta[:format](text), meta, doc.modname)
    end
    
    # handle internal typed docstrings
    function Entry(source, doc::Documentation, text::Docstring, meta::Dict = Dict{Symbol, Any}())
        push!(meta, :source, source)
        new(text, meta, doc.modname)
    end

    Entry(args...) = error("@doc: incorrect arguments given to docstring macro:\n$(args)")
end

@docref () -> REF_MANUAL
type Manual
    pages::Vector{(String, Docstring)}
    
    function Manual(root, files)
        root = abspath(dirname(root))
        new([(f = joinpath(root, file); (abspath(f), formatted(f))) for file in files])
    end
end

# Usage from REPL, use current directory as root.
Manual(::Nothing, files) = Manual(pwd(), files)

const DOCUMENTATION_METADATA = [
    :manual => String[],
    :format => MarkdownDocstring
    ]

@docref () -> REF_DOCUMENTATION
type Documentation
    modname::Module
    manual::Manual
    entries::Dict{Any, Entry}
    meta::Dict{Symbol, Any}
    
    function Documentation(m::Module, root, manual::Vector)
        Base.warn_once("""
        @docstrings with a vector argument is deprecated and will be
        removed in version 0.3.0.
        
        Use a Dict{Symbol, Any} instead. To specify the manual section
        use the following:
        
        @docstrings [
            :manual => ["../doc/maunal.md"]
        ]
        """)
        
        meta = copy(DOCUMENTATION_METADATA)
        meta[:manual] = manual
        
        new(m, Manual(root, manual), Dict{Any, Entry}(), meta)
    end
    
    function Documentation(m::Module, root, meta::Dict = Dict{Symbol, Any}())
        # override default metadata with that provided by @docstrings
        meta = merge(DOCUMENTATION_METADATA, meta)
        new(m, Manual(root, meta[:manual]), Dict{Any, Entry}(), meta)
    end
end

function push!(docs::Documentation, object, cat, source, data...)
    haskey(docs.entries, object) && warn("@doc: overwriting object $(object)")
    docs.entries[object] = Entry{cat}(source, docs, data...)
    nothing
end

# For methods since setdiff is used to find new method definitions.
function push!(docs::Documentation, objects::Set, cat, source, data...)
    ent = Entry{cat}(source, docs, data...)
    for object in objects
        haskey(docs.entries, object) && warn("@doc: overwriting object $(object)")
        docs.entries[object] = ent
    end
end
