type Entry{category} # category::Symbol allows for different formatting of object output.
    docs::Markdown.Block
    meta::Dict{Symbol, Any}
    function Entry(docs, meta)
        if haskey(meta, :file)
            docs = readall(joinpath(dirname(docs), meta[:file]))
        end
        new(Markdown.parse(docs), meta)
    end
end

type Documentation
    modname::Module
    docs::Dict{Any, Entry}
    Documentation(m::Module) = new(m, Dict{Any, Entry}())
end

function push!(d::Documentation, k, ent::Entry)
    haskey(d.docs, k) && warn("overwriting `$(k)`.")
    push!(d.docs, k, ent)
end

immutable MetaContainer{symb}
    content
end
