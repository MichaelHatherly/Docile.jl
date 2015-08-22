OS_NAME == :Windows && Pkg.add("FactCheck")

module DocileTests

using Docile, FactCheck

include("TestModule.jl")

facts("Directive parsing.") do
    @fact Docile.Docs.parsebrackets("@{}") --> [(:docs, "")]
    @fact Docile.Docs.parsebrackets("@{x}") --> [(:docs, "x")]
    @fact Docile.Docs.parsebrackets("@{ref:}") --> [(:ref, "")]
    @fact Docile.Docs.parsebrackets("@{a1: }") --> [(:a1, " ")]
    @fact Docile.Docs.parsebrackets("@") --> [(:text, "@")]
    @fact Docile.Docs.parsebrackets("@}") --> [(:text, "@}")]
    @fact Docile.Docs.parsebrackets("@{a1}") --> [(:docs, "a1")]

    @fact_throws ParseError Docile.Docs.parsebrackets("@{")
    @fact_throws ParseError Docile.Docs.parsebrackets("@{{}")
end

facts("Docsystem hooks.") do

    doc = @doc(TestModule.TestModule)
    @fact typeof(doc) --> Docile.Docs.LazyDoc

    blocks = [
        (:docs, "x"),
        (:text, "\n"),
        (:ref, "x"),
        (:text, "\n"),
        (:esc, "ref:x"),
        (:text, "\n"),
        (:repl, "\njulia> a = 1\n"),
        (:text, "\n"),
        (:example, "\na = 1\n"),
        (:text, "\n"),
    ]
    @fact doc.blocks --> blocks

end

facts("Build docs.") do
    makedocs(
        source = "test-source",
        build  = "test-build",
        clean  = true,
    )

    @fact isdir(joinpath(Base.source_dir(), "test-source")) --> true
    @fact isdir(joinpath(Base.source_dir(), "test-build")) --> true
    @fact isdir(joinpath(Base.source_dir(), "test-build", "c")) --> true

    @fact isfile(joinpath(Base.source_dir(), "test-build", "a.md")) --> true
    @fact isfile(joinpath(Base.source_dir(), "test-build", "b.md")) --> true
    @fact isfile(joinpath(Base.source_dir(), "test-build", "c", "a.md")) --> true
    @fact isfile(joinpath(Base.source_dir(), "test-build", "c", "b.md")) --> true
end

end
