module InterfaceTests

using Docile, Docile.Interface, FactCheck

facts("Interface.") do

    context("Module.") do

        @fact isempty(documented()) => false
        @fact typeof(documented())  => Set{Module}

        @fact isdocumented(Docile)           => true
        @fact isdocumented(Docile.Interface) => true
        @fact isdocumented(Base)             => false

        @fact typeof(metadata(Docile)) => Metadata

        @fact_throws metadata(Base) ArgumentError

    end

    context("Metadata.") do

        @fact typeof(modulename(metadata(Docile))) => Module

        @fact isempty(manual(metadata(Docile))) => true
        @fact typeof(manual(metadata(Docile)))  => Vector{UTF8String}

        @fact isempty(entries(metadata(Docile))) => false
        @fact typeof(entries(metadata(Docile)))  => ObjectIdDict

        @fact root(metadata(Docile))           => Pkg.dir("Docile", "src", "Docile.jl")
        @fact root(metadata(Docile.Interface)) => Pkg.dir("Docile", "src", "interface.jl")

        dir = Pkg.dir("Docile", "src")

        interface_files = Set{UTF8String}([joinpath(dir, "interface.jl")])
        docile_files    = Set{UTF8String}([joinpath(dir, f) for f in readdir(dir)])

        @fact isempty(setdiff(files(metadata(Docile)), docile_files))              => true
        @fact isempty(setdiff(files(metadata(Docile.Interface)), interface_files)) => true

        @fact isloaded(metadata(Docile))           => true
        @fact isloaded(metadata(Docile.Interface)) => true

        @fact isempty(metadata(metadata(Docile))) => false
        @fact typeof(metadata(metadata(Docile)))  => Dict{Symbol, Any}

        s = symbol("@doc")
        λ = getfield(Docile, s)
        @fact Docile.Interface.macroname(entries(metadata(Docile))[λ]) => s

        @fact Docile.Interface.name(isempty)                 => :isempty
        @fact Docile.Interface.name(:isempty)                => :isempty
        @fact Docile.Interface.name(first(methods(isempty))) => :isempty

    end

    context("Entry.") do

        @fact modulename(entries(metadata(Docile))[Docile.Entry]) => Docile

        meth = first(methods(Docile.Interface.modulename))
        @fact modulename(entries(metadata(Docile.Interface))[meth]) => Docile.Interface

        @fact isempty(metadata(entries(metadata(Docile))[Docile.Entry])) => false
        @fact typeof(metadata(entries(metadata(Docile))[Docile.Entry])) =>  Dict{Symbol, Any}

        @fact typeof(docs(entries(metadata(Docile))[Docile.Entry])) => Docile.Docs{:md}

    end

    context("Docs.") do

        @fact isempty(data(docs(entries(metadata(Docile))[Docile.Entry]))) => false
        @fact typeof(data(docs(entries(metadata(Docile))[Docile.Entry])))  => ASCIIString

        @fact format(docs(entries(metadata(Docile))[Docile.Entry])) => :md

        @fact_throws parsed(docs(entries(metadata(Docile))[Docile.Entry]))

        @fact parsedocs(Docile.Docs{:txt}("")) => ""

        @fact_throws parsedocs(Docile.Docs{:md}(""))

    end

    context("Deprecated.") do

        @fact documentation(Docile)           => metadata(Docile)
        @fact documentation(Docile.Interface) => metadata(Docile.Interface)

    end

end

end
