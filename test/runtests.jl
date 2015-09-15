
using Docile # Needs to be available in `Main` for `makedocs` tests to work.

module Tests

import Docile

using FactCheck
FactCheck.setstyle(:compact)

import Docile.Utilities: @H_str

let u = Docile.Utilities
    facts("Utilities") do
        @fact u.Head(:(1 + 2)) --> u.Head{:call}()
        @fact u.Head(1) --> u.Head{:__none__}()
        @fact H"function, =" --> Union{u.Head{:function}, u.Head{:(=)}}
        @fact u.tryget(Tests, :foo, 1) --> 1
        @fact u.tryget(Docile, :Utilities, 1) --> u
        @fact u.exports(Tests) --> ""
        @fact u.exports(Docile) -->
        """
        **Exported Names:**

        - `Hooks`
        - `details`
        - `doctest`
        - `makedocs`
        - `register!`
        """
        @fact u.submodules(Test) --> Set([Test])
        @fact u.submodules(Docile) --> Set([
            Docile, Docile.Utilities, Docile.Builder, Docile.DocTree,
            Docile.Hooks, Docile.Parser, Docile.Tester, Docile.Queries,
        ])
        @fact u.evalblock(Module(), "1 + 1") --> 2
        @fact u.parseblock("a = 1\nb = a + 1") --> [
            (:(a = 1), "a = 1\n"), (:(b = a + 1), "b = a + 1")
        ]
        let n = u.getobject(Tests, "Docile.Parser.parsedocs")
            @fact isnull(n) --> false
            isnull(n) || (@fact get(n) --> Docs.@var(Docile.Parser.parsedocs))
        end
        let n = u.getobject(Tests, "foobar")
            @fact isnull(n) --> true
        end
        let n = u.getmodule(Tests, "Docile")
            @fact isnull(n) --> false
            isnull(n) || (@fact get(n) --> Docile)
        end
        let n = u.getobject(Tests, "Utilities")
            @fact isnull(n) --> true
        end
        let x = [1, 2, 3]
            u.concat!(x, 1)
            @fact x --> [1, 2, 3, 1]
            u.concat!(x, [2, 3])
            @fact x --> [1, 2, 3, 1, 2, 3]
        end
    end
end

let p = Docile.Parser
    facts("Parser") do
        @fact p.parsedocs("") --> []
        @fact p.parsedocs("@{}") --> [(:docs, "")]
        @fact p.parsedocs("@esc{ }") --> [(:esc, " ")]
        @fact p.parsedocs("@code {}") --> [(:esc, "@code {}")]
        @fact p.parsedocs("@{}@{}") --> [(:docs, ""), (:docs, "")]
        @fact p.parsedocs("@}") --> [(:esc, "@}")]
        @fact_throws ParseError p.parsedocs("@{")
    end
end

module TestHooks

using Docile

register!(
    Hooks.directives,
    Hooks.__doc__,
    Hooks.doc!args,
    Hooks.doc!kwargs,
    Hooks.doc!sig,
)

"""
    $doc!sig

$doc!args

$doc!kwargs
"""
function test(
    "one",
    one,
    "two",
    two,
    three
    ;
    "four",
    four = 4,
    )
end

"$doc!sig"
const C = 1

"$doc!sig"
f(x) = x

"$doc!sig"
abstract A

"$doc!sig"
type T <: A end

"$doc!sig"
bitstype 8 B

end

let h = Docile.Hooks
    facts("Hooks") do
        @fact h.hooks(TestHooks) --> [
            h.directives,
            h.__doc__,
            h.doc!args,
            h.doc!kwargs,
            h.doc!sig,
        ]
        @fact stringmime("text/plain", @doc(TestHooks.test)) -->
        """
            test(one,two,three; four=4)\n
        **Arguments:**\n
        `one`:\n
        one\n
        `two`:\n
        two
        \n\n\n
        **Keywords:**\n
        `four=4`:\n
        four
        \n\n
        """
        @fact stringmime("text/plain", @doc(TestHooks.C)) --> "C"
        @fact stringmime("text/plain", @doc(TestHooks.f)) --> "f(x)"
        @fact stringmime("text/plain", @doc(TestHooks.A)) --> "abstract A"
        @fact stringmime("text/plain", @doc(TestHooks.T)) --> "T <: A"
        @fact stringmime("text/plain", @doc(TestHooks.B)) --> "bitstype 8 B"
    end
end

let d = Docile.DocTree
    facts("DocTree") do
        @fact d.Chunk((:esc, "")) --> d.Chunk(:esc, "", false)
        @fact d.Node("") --> d.Node([], current_module())
        @fact d.Node("@{foobar}@code{...}") --> d.Node(
            [d.Chunk(:docs, "foobar", false), d.Chunk(:code, "...", false)],
            current_module(),
        )
        @fact d.exprnode("") --> :(Main.Docile.DocTree.Node(""))
        @fact d.File(joinpath(dirname(@__FILE__), "file.md"), "") --> d.File(
            [d.Node([], current_module())], joinpath(dirname(@__FILE__), "file.md"), "",
        )
        root = d.Root([], "", MIME"text/markdown"())
        @fact root --> d.Root(
            [], ObjectIdDict(), "", MIME"text/markdown"(),
        )
        d.expand!(root)
        @fact root --> d.Root(
            [], ObjectIdDict(), "", MIME"text/markdown"(),
        )
    end
end

import Docile.Queries:
    Text, RegexTerm,
    Object, Metadata,
    MatchAnyThing,
    ArgumentTypes,
    ReturnTypes,
    And, Or, Not,
    exec,
    @query_str

let q = Docile.Queries
    function check(query, term, index)
        @fact query.term  --> term
        @fact query.index --> index
    end
    check(query, term) = @fact(query.term  --> term)
    facts("Queries") do
        check(query"facts", Object(FactCheck, :facts, facts))
        check(query"\"...\"", Text("..."))
        check(query"FactCheck.facts 1", Object(FactCheck, :facts, facts), 1)
        let λ = getfield(FactCheck, symbol("@fact"))
            check(query"@fact", Object(FactCheck, symbol("@fact"), λ))
            check(query"FactCheck.@fact() 1", Object(FactCheck, symbol("@fact"), λ), 1)
        end
        check(query"::Bool", ReturnTypes(Bool))
        check(query"::(Int, Any)", ReturnTypes(Tuple{Int, Any}))
        check(query"facts(Int,)::Bool",
            And(And(Object(FactCheck, :facts, facts),
                ArgumentTypes(Tuple{Int})),
            ReturnTypes(Bool)))
        check(query"r\"...\" 1", RegexTerm(r"..."), 1)
        let λ = getfield(Base, symbol("@r_str"))
            check(query"r\"\"", Object(Base, symbol("@r_str"), λ))
        end
        check(query"[a = 1, b, c = 3]", Metadata(
            Any[(:a, 1), (:b, MatchAnyThing()), (:c, 3)])
        )
        let atinbounds = getfield(Base, symbol("@inbounds")),
            atfact     = getfield(FactCheck, symbol("@fact"))
            check(query"facts | @inbounds() & !context | @fact()",
                Or(Or(Object(FactCheck, :facts, facts),
                    And(Object(Base, symbol("@inbounds"), atinbounds),
                        Not(Object(FactCheck, :context, context)))),
                    Object(FactCheck, symbol("@fact"), atfact)))
        end
        queries = (
            query"Docile",
            query"Docile.Utilities",
            query"Docile.Parser.parsedocs",
            query"@query_str",
            query"Docile.Queries.@query_str",
            query"\"...\"",
            query"\"\"",
            query"r\"...\"",
            query"r\"\"",
            query"[a]",
            query"[a = 1]",
            query"[category = :function]",
            query"(Any,)",
            query"::Any",
            query"(Any, Any)::(Int,)",
            query"facts(Int)::Int",
            query"Docile.Queries.build(AbstractString)",
            query"Docile & \"...\" | [a] & (Any,)",
            query"Docile | \"\" & [a = 1] | ::Any",
            query"Docile.Builder & [category = :function]",
            query"!@query_str() | (Any, Any)::(Int,) | facts(Int)::Int",
            query"Docile.Queries.@query_str() & Docile.Queries.build(AbstractString)",
            )
        map(exec, queries)
        map(q -> stringmime("text/plain", q), queries)
    end
end

let b = Docile.Builder
    facts("Builder") do
        doc_source   = joinpath(dirname(@__FILE__), "..", "doc", "src")
        makedocs_dir = joinpath(dirname(@__FILE__), "makedocs")
        build_dir    = joinpath(makedocs_dir, "build")
        source_dir   = joinpath(makedocs_dir, "src")
        cp(doc_source, source_dir, remove_destination = true)
        b.makedocs(
            source   = source_dir,
            build    = build_dir,
            clean    = true,
            verbose  = false,
            external = Dict(),
        )
        @fact isdir(build_dir) --> true
        @fact isfile(joinpath(build_dir, "SUMMARY.md")) --> true
        @fact isfile(joinpath(build_dir, "README.md")) --> true
        @fact isfile(joinpath(build_dir, "public.md")) --> true
        @fact isfile(joinpath(build_dir, "internals.md")) --> true
        b.makedocs(
            source   = source_dir,
            build    = build_dir,
            clean    = true,
            verbose  = false,
            format   = :html,
            external = Dict(),
        )
        @fact isdir(build_dir) --> true
        @fact isfile(joinpath(build_dir, "README.html")) --> true
        @fact isfile(joinpath(build_dir, "public.html")) --> true
        @fact isfile(joinpath(build_dir, "internals.html")) --> true
    end
end

let t = Docile.Tester
    facts("Tester") do
        results = t.doctest(Docile)
        @fact stringmime("text/plain", results) -->
        """
        Results(
         total: 6,
        passed: 6,
        failed: 0,
        )
        """
        let buf = IOBuffer()
            t.details(buf, results, true)
            @fact position(buf) > 0 --> true
        end
        @fact length(t.passed(results)) --> 6
        @fact length(t.failed(results)) --> 0
    end
end

FactCheck.exitstatus()

end
