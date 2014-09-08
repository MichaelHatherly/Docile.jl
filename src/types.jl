@docref () -> REF_ENTRY_TYPE
type Entry{category} # category::Symbol
    docs::Markdown.Block
    meta::Dict{Symbol, Any}

    function Entry(source, meta::Dict)
        push!(meta, :source, source)
        docs = haskey(meta, :file) ?
            Markdown.parse_file(joinpath(dirname(source[2]), meta[:file])) :
            Markdown.parse("")
        new(docs, meta)
    end

    function Entry(source, text::String, meta::Dict = Dict{Symbol, Any}())
        push!(meta, :source, source)
        new(Markdown.parse(text), meta)
    end

    Entry(args...) = error("@doc: incorrect arguments given to docstring macro:\n$(args)")
end

type Entries
    entries::Vector{(Any, Entry)}
    Entries() = new((Any, Entry)[])
end

push!(ents::Entries, obj, ent::Entry) = push!(ents.entries, (obj, ent))

length(ents::Entries) = length(ents.entries)

@docref () -> REF_DOCUMENTATION_TYPE
type Documentation
    modname::Module
    entries::Dict{Any, Entry}
    Documentation(m::Module) = new(m, Dict{Any, Entry}())
end

function push!(docs::Documentation, object, ent::Entry)
    haskey(docs.entries, object) && warn("@doc: overwriting object $(object)")
    docs.entries[object] = ent
end
