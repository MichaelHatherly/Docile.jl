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

end
