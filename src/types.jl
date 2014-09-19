@docref () -> REF_ENTRY
type Entry{category} # category::Symbol
    docs::String
    meta::Dict{Symbol, Any}

    # handle external docstrings
    function Entry(source, doc::Documentation, meta::Dict)
        push!(meta, :source, source)
        text = haskey(meta, :file) ? readall(joinpath(dirname(source[2]), meta[:file])) : ""
        new(text, meta)
    end

    # handle internal docstrings
    function Entry(source, doc::Documentation, text::String, meta::Dict = Dict{Symbol, Any}())
        push!(meta, :source, source)
        new(text, meta)
    end

    Entry(args...) = error("@doc: incorrect arguments given to docstring macro:\n$(args)")
end

@docref () -> REF_MANUAL
type Manual
    pages::Vector{(String, String)}
    
    function Manual(root, files)
        new([(f = joinpath(root, file); (abspath(f), readall(f))) for file in files])
    end
end

const DOCUMENTATION_METADATA = [
    :manual => String[]
    ]

@docref () -> REF_DOCUMENTATION
type Documentation
    modname::Module
    manual::Manual
    entries::Dict{Any, Entry}
    metadata::Dict{Symbol, Any}
    
    # DEPRECIATION -- 0.3 removal.
    function Documentation(m::Module, root::String, manual::Vector)
        Base.warn_once("""
        @docstrings with a vector argument is depreciated. Use a Dict{Symbol, Any}
        instead. To specify the manual section use the following:
        
        @docstrings [
            :manual => ["../doc/maunal.md", "../doc/interface.md"]
        ]
        """)
        
        meta = copy(DOCUMENTATION_METADATA)
        meta[:manual] = manual
        
        new(m, Manual(root, manual), Dict{Any, Entry}(), meta)
    end
    
    function Documentation(m::Module, root::String, meta::Dict = Dict{Symbol, Any}())
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

function push!(docs::Documentation, objects::Set, args...)
    for object in objects
        push!(docs, object, args...)
    end
end
