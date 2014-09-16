@docref () -> REF_ENTRY
type Entry{category} # category::Symbol
    docs::String
    meta::Dict{Symbol, Any}

    function Entry(source, meta::Dict)
        push!(meta, :source, source)
        docs = haskey(meta, :file) ? readall(joinpath(dirname(source[2]), meta[:file])) : ""
        new(docs, meta)
    end

    function Entry(source, text::String, meta::Dict = Dict{Symbol, Any}())
        push!(meta, :source, source)
        new(text, meta)
    end

    Entry(args...) = error("@doc: incorrect arguments given to docstring macro:\n$(args)")
end

@docref () -> REF_MANUAL
type Manual
    pages::Vector{(String, String)}
    
    Manual(files) = new([(abspath(file), readall(file)) for file in files])
end

@docref () -> REF_DOCUMENTATION
type Documentation
    modname::Module
    manual::Manual
    entries::Dict{Any, Entry}
    
    Documentation(m::Module, files = String[]) = new(m, Manual(files), Dict{Any, Entry}())
end

function push!(docs::Documentation, object, ent::Entry)
    haskey(docs.entries, object) && warn("@doc: overwriting object $(object)")
    docs.entries[object] = ent
    nothing
end

function push!(docs::Documentation, objects::Set, ent::Entry)
    for object in objects
        push!(docs, object, ent)
    end
end
