facts("Interface.") do

    context("Module.") do

        @fact isempty(Docile.Interface.documented()) --> false
        @fact typeof(Docile.Interface.documented())  --> Set{Module}

        @fact Docile.Interface.isdocumented(Docile)           --> true
        @fact Docile.Interface.isdocumented(Docile.Interface) --> true

        @fact typeof(Docile.Interface.metadata(Docile)) --> Docile.Interface.Metadata

    end

    context("Metadata.") do

        meta = Docile.Interface.metadata(Docile)

        @fact typeof(Docile.Interface.modulename(meta)) --> Module

        @fact isempty(Docile.Interface.manual(meta)) --> true
        @fact typeof(Docile.Interface.manual(meta))  --> Vector{String}

        @fact isempty(Docile.Interface.entries(meta))                                    --> false
        @fact isempty(Docile.Interface.entries(Docile.Interface.metadata(Docile.Cache))) --> false

        @fact typeof(Docile.Interface.entries(meta)) --> ObjectIdDict

        dir = Pkg.dir("Docile", "src", "Docile.jl")
        @fact Docile.Interface.root(meta)                                    --> dir

        dir = Pkg.dir("Docile", "src", "Cache", "Cache.jl")
        @fact Docile.Interface.root(Docile.Interface.metadata(Docile.Cache)) --> dir

        @fact isempty(Docile.Interface.metadata(meta)) --> false
        @fact typeof(Docile.Interface.metadata(meta))  --> Dict{Symbol, Any}

        legacy = Docile.Interface.metadata(Docile.Legacy)
        s = symbol("@comment")
        λ = getfield(Docile.Legacy, s)
        @fact Docile.Interface.macroname(Docile.Interface.entries(legacy)[λ]) --> s

        @fact Docile.Interface.name(isempty)                 --> :isempty
        @fact Docile.Interface.name(:isempty)                --> :isempty
        @fact Docile.Interface.name(first(methods(isempty))) --> :isempty
        @fact Docile.Interface.name(Docile)                  --> :Docile
        @fact Docile.Interface.name(Docile.Legacy.Metadata)  --> :Metadata

        @fact Docile.Interface.files(meta)                --> Set{String}()
        @fact Docile.Interface.isloaded(meta)             --> true
        @fact Docile.Interface.isexported(Docile, Docile) --> true

        cache = Docile.Interface.metadata(Docile.Cache)
        comment = first(filter(k -> isa(k, Docile.Legacy.Comment), keys(Docile.Interface.entries(cache))))
        @fact Docile.Interface.isexported(Docile.Cache, comment) --> false

    end

    context("Entry.") do

        meta = Docile.Interface.metadata(Docile.Cache)
        doc =  Docile.Interface.entries(meta)[first(methods(Docile.Cache.clear!))]

        @fact Docile.Interface.category(doc) --> :method

        @fact Docile.Interface.modulename(doc) --> Docile.Cache

        @fact isempty(Docile.Interface.metadata(doc)) --> false
        @fact typeof(Docile.Interface.metadata(doc))  --> Dict{Symbol, Any}

        @fact typeof(Docile.Interface.docs(doc)) --> Docile.Interface.Docs{:md}

    end

    context("Docs.") do

        meta = Docile.Interface.metadata(Docile.Cache)
        ent =  Docile.Interface.entries(meta)[first(methods(Docile.Cache.clear!))]
        doc =  Docile.Interface.docs(ent)

        @fact isempty(Docile.Interface.data(doc)) --> false
        @fact isa(Docile.Interface.data(doc), String) --> true

        @fact Docile.Interface.format(doc) --> :md

        @fact Docile.Interface.parsedocs(Docile.Interface.Docs{:txt}("")) --> ""

        @fact_throws Docile.Interface.parsed(doc)

        @fact_throws Docile.Interface.parsedocs(Docile.Interface.Docs{:md}(""))

    end

    context("Deprecated.") do

        @fact typeof(Docile.Interface.documentation(Docile)) --> Docile.Legacy.Metadata

    end

end
