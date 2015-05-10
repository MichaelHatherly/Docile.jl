facts("Interface.") do

    context("Module.") do

        @fact isempty(Docile.Interface.documented()) => false
        @fact typeof(Docile.Interface.documented())  => Set{Module}

        @fact Docile.Interface.isdocumented(Docile)           => true
        @fact Docile.Interface.isdocumented(Docile.Interface) => true

        @fact typeof(Docile.Interface.metadata(Docile)) => Docile.Interface.Metadata

    end

    context("Metadata.") do

        meta = Docile.Interface.metadata(Docile)

        @fact typeof(Docile.Interface.modulename(meta)) => Module

        @fact isempty(Docile.Interface.manual(meta)) => true
        @fact typeof(Docile.Interface.manual(meta))  => Vector{UTF8String}

        @fact isempty(Docile.Interface.entries(meta))                                    => true
        @fact isempty(Docile.Interface.entries(Docile.Interface.metadata(Docile.Cache))) => false

        @fact typeof(Docile.Interface.entries(meta)) => ObjectIdDict

        dir = Pkg.dir("Docile", "src", "Docile.jl")
        @fact Docile.Interface.root(meta)                                    => dir

        dir = Pkg.dir("Docile", "src", "Cache", "Cache.jl")
        @fact Docile.Interface.root(Docile.Interface.metadata(Docile.Cache)) => dir

        @fact isempty(Docile.Interface.metadata(meta)) => false
        @fact typeof(Docile.Interface.metadata(meta))  => Dict{Symbol, Any}

        legacy = Docile.Interface.metadata(Docile.Legacy)
        s = symbol("@comment")
        λ = getfield(Docile.Legacy, s)
        @fact Docile.Interface.macroname(Docile.Interface.entries(legacy)[λ]) => s

        @fact Docile.Interface.name(isempty)                 => :isempty
        @fact Docile.Interface.name(:isempty)                => :isempty
        @fact Docile.Interface.name(first(methods(isempty))) => :isempty

    end

    context("Entry.") do

        meta = Docile.Interface.metadata(Docile.Cache)
        doc =  Docile.Interface.entries(meta)[first(methods(Docile.Cache.clear!))]

        @fact Docile.Interface.modulename(doc) => Docile.Cache

        @fact isempty(Docile.Interface.metadata(doc)) => false
        @fact typeof(Docile.Interface.metadata(doc))  => Dict{Symbol, Any}

        @fact typeof(Docile.Interface.docs(doc)) => Docile.Interface.Docs{:md}

    end

    context("Docs.") do

        meta = Docile.Interface.metadata(Docile.Cache)
        ent =  Docile.Interface.entries(meta)[first(methods(Docile.Cache.clear!))]
        doc =  Docile.Interface.docs(ent)

        @fact isempty(Docile.Interface.data(doc)) => false
        @fact typeof(Docile.Interface.data(doc))  => ASCIIString

        @fact Docile.Interface.format(doc) => :md

        @fact_throws Docile.Interface.parsed(doc)

        @fact_throws Docile.Interface.parsedocs(Docile.Interface.Docs{:md}(""))

    end

end
