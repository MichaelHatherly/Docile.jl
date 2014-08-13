type Entry
    docstring::Markdown.Block
    metadata::Dict{String, Any}
end

type Documentation
    modname::Module
    methods::Dict{Method, Entry}
    Documentation(m::Module, methods = Dict{Method, Entry}()) = new(m, methods)
end
