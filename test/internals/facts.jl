module InternalTests

using Docile, Docile.Interface, FactCheck

facts("Internals.") do

    context("Metadata.") do

        @fact copy(metadata(Docile))           => metadata(Docile)
        @fact copy(metadata(Docile.Interface)) => metadata(Docile.Interface)

    end

    context("Code execution.") do

        m = Module()
        s = Docile.State(m)

        @fact Docile.exec(s, :(1:3:10)) => 1:3:10
        @fact Docile.exec(s, :([1, 2, 3])) => [1, 2, 3]
        @fact Docile.exec(s, :([1 2 3 4])) => [1 2 3 4]
        @fact Docile.exec(s, :(1 + 2 * 3)) => 1 + 2 * 3

        @fact Docile.exec(s, :([1, 2, 3, 4, 5][1:2])) => [1, 2, 3, 4, 5][1:2]
        @fact Docile.exec(s, :([1:100][end])) => [1:100][end]

        @fact Docile.exec(s, :(zeros(Int, 3, 3))) => zeros(Int, 3, 3)

        @fact Docile.exec(s, :((Int, Float64, Vector))) => (Int, Float64, Vector)
        @fact Docile.exec(s, :(Union(Symbol, Expr))) => Union(Symbol, Expr)
        @fact Docile.exec(s, :(Array{Int, 3})) => Array{Int, 3}

        @fact Docile.exec(s, :(current_module())) => InternalTests

        @fact Docile.exec(s, :(@__FILE__)) => @__FILE__
        @fact Docile.exec(s, :(MIME"text/plain")) => MIME"text/plain"

        @fact isempty(s.scopes) => true
        Docile.addtoscope!(s, :T, TypeVar(:T, Integer))
        @fact length(s.scopes) => 1

        @fact Docile.exec(s, :(Matrix{T})) => Matrix{TypeVar(:T, Integer)}
        @fact Docile.exec(s, :(Type{Complex{T}})) => Type{Complex{TypeVar(:T, Integer)}}

        Docile.popscope!(s)
        @fact isempty(s.scopes) => true

    end

end

end
