OS_NAME == :Windows && Pkg.add("FactCheck")

module DocileTests

using Docile, FactCheck

include("TestModule.jl")
include("HookTests.jl")

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

    typedoc = TypeFieldDocs.__META__[TypeFieldDocs.T]
    @fact typedoc.main --> doc"T"
    @fact typedoc.fields[:x] --> doc"x"

    funcdoc = VecDoc.__META__[VecDoc.f]
    @fact funcdoc.main --> doc"f, g"

    funcdoc = VecDoc.__META__[VecDoc.g]
    @fact funcdoc.main --> doc"f, g"

    typedoc = DocMeta.__META__[DocMeta.T]
    @fact typedoc.main --> doc"T"

end

facts("Directives.") do
    source = "@{Base.@time}"
    name, text = Docile.Docs.parsebrackets(source)[1]
    directive = Docile.Docs.exec(name, text, Docile.Docs.File())[1]
    @fact directive.object --> Docile.Utilities.@object(Base.@time)
    @fact directive.docs --> @doc(Base.@time)
    @fact directive.id --> 1

    source = "..."
    name, text = Docile.Docs.parsebrackets(source)[1]
    directive = Docile.Docs.exec(name, text, Docile.Docs.File())
    @fact directive.text --> "..."

    source = "@{esc:foobar:...}"
    name, text = Docile.Docs.parsebrackets(source)[1]
    directive = Docile.Docs.exec(name, text, Docile.Docs.File())
    @fact directive.text --> "foobar:..."

    source = "@{ref:Base.@time}"
    name, text = Docile.Docs.parsebrackets(source)[1]
    directive = Docile.Docs.exec(name, text, Docile.Docs.File())
    @fact directive.text --> "Base.@time"
    @fact directive.object --> Docile.Utilities.@object(Base.@time)
    @fact directive.refs --> Dict()

    source =
    """
    @{repl:
    julia> a = 1;
    julia> b = 2
    julia> a + b
    }
    """
    name, text = Docile.Docs.parsebrackets(source)[1]
    directive = Docile.Docs.exec(name, text, Docile.Docs.File())
    @fact typeof(directive.mod) --> Module
    @fact isdefined(directive.mod, :a) --> true
    @fact isdefined(directive.mod, :b) --> true
    @fact directive.lines --> [
        "a = 1;",
        "b = 2",
        "a + b",
    ]
    @fact directive.results --> [
        1,
        2,
        3,
    ]

    source =
    """
    @{example:
    a = 1
    b = 2
    c = a + b
    }
    """
    name, text = Docile.Docs.parsebrackets(source)[1]
    directive = Docile.Docs.exec(name, text, Docile.Docs.File())
    @fact typeof(directive.mod) --> Module
    @fact isdefined(directive.mod, :a) --> true
    @fact isdefined(directive.mod, :b) --> true
    @fact isdefined(directive.mod, :c) --> true
    @fact directive.source --> "a = 1\nb = 2\nc = a + b"
    @fact directive.result --> 3
end

facts("Object display methods.") do
    buffer = IOBuffer()

    path = joinpath(Base.source_dir(), "test-source", "a.md")
    root = Docile.Docs.Root(path => "")
    writemime(buffer, "text/plain", root)
    @fact takebuf_string(buffer) -->
    """
    Root(
     files
      \"$(path)\"=>\"\"
     refs
      Base.@time (\"$(path)\"=>\"\",1)
    )"""

    lazydoc = Docile.Docs.LazyDoc("@{esc:foo:...}")
    writemime(buffer, "text/plain", lazydoc)
    @fact takebuf_string(buffer) --> "@{foo:...}\n"

    lazydoc = Docile.Docs.LazyDoc("""
    @{repl:
    julia> a = 1;
    julia> b = 2
    julia> a + b
    }
    """)
    writemime(buffer, "text/plain", lazydoc)
    @fact takebuf_string(buffer) -->
    """
    ```
    julia> a = 1;

    julia> b = 2
    2

    julia> a + b
    3

    ```
    """

    lazydoc = Docile.Docs.LazyDoc("""
    @{example:
    a = 1
    b = 2
    a + b
    }
    """)
    writemime(buffer, "text/plain", lazydoc)
    @fact takebuf_string(buffer) -->
    """
    ```
    a = 1
    b = 2
    a + b
    ```

    *Result*

    ```
    3
    ```
    """

end

facts("Utilities module.") do
    f(x) = x
    f(x, y) = x + y

    @fact Docile.Utilities.@object(f(::Any)) --> methods(f, Tuple{Any})[1]
    @fact Docile.Utilities.@object(f(::Any, ::Any)) --> methods(f, Tuple{Any, Any})[1]

    @fact Docile.Utilities.@object(f(1)) --> methods(f, Tuple{Any})[1]
    @fact Docile.Utilities.@object(f(1, 1)) --> methods(f, Tuple{Any, Any})[1]

    @fact Docile.Utilities.@object(1) --> 1

    xs = [1, 2, 3]
    @fact Docile.Utilities.concat!(xs, 1) --> [1, 2, 3, 1]
    @fact Docile.Utilities.concat!(xs, [1, 2]) --> [1, 2, 3, 1, 1, 2]
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

facts("Doctests.") do
    doctest(Docile, submodules = false)
    results = doctest(Docile)
    @fact typeof(results) --> Docile.Testing.Results
    details(IOBuffer(), results, false)
    details(IOBuffer(), results, true)
    @fact length(Docile.Testing.failed(results)) --> 0
end

end
