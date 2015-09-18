module m end

facts("Runner.") do

     context("Code execution.") do

        s = Docile.Runner.State(m)

        @fact Docile.Runner.exec(s, :(1:3:10)) --> 1:3:10
        @fact Docile.Runner.exec(s, :([1, 2, 3])) --> [1, 2, 3]
        @fact Docile.Runner.exec(s, :([1 2 3 4])) --> [1 2 3 4]
        @fact Docile.Runner.exec(s, :(1 + 2 * 3)) --> 1 + 2 * 3

        @fact Docile.Runner.exec(s, :([1, 2, 3, 4, 5][1:2])) --> [1, 2, 3, 4, 5][1:2]
        @fact Docile.Runner.exec(s, :([1:100;][end])) --> [1:100;][end]

        @fact Docile.Runner.exec(s, :(zeros(Int, 3, 3))) --> zeros(Int, 3, 3)

        @fact Docile.Runner.exec(s, :((Int, Float64, Vector))) --> (Int, Float64, Vector)
        @fact Docile.Runner.exec(s, :(Array{Int, 3})) --> Array{Int, 3}

        @fact Docile.Runner.exec(s, :(current_module())) --> Main

        @fact Docile.Runner.exec(s, :(@__FILE__)) --> @__FILE__
        @fact Docile.Runner.exec(s, :(MIME"text/plain")) --> MIME"text/plain"

        @fact isempty(s.scopes) --> true
        Docile.Runner.addtoscope!(s, :T, TypeVar(:T, Integer))
        @fact length(s.scopes) --> 1

        @fact Docile.Runner.getvar(s, :T) --> TypeVar(:T, Integer)

        @fact Docile.Runner.exec(s, :(Matrix{T})) --> Matrix{TypeVar(:T, Integer)}
        @fact Docile.Runner.exec(s, :(Type{Complex{T}})) --> Type{Complex{TypeVar(:T, Integer)}}

        Docile.Runner.popscope!(s)
        @fact isempty(s.scopes) --> true

    end

end
