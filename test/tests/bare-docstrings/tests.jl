using Docile, Lexicon, Base.Test

@document options() ->

module TestBareStrings

include("A.jl")

"One line, short method doc."
f1(x) = x

"One line, long method doc."
function f2(x)
    x
end

"""
Multiline, short method doc.
"""
f3(x) = x

"""
Multiline, long method doc.
"""
function f4(x)
    x
end

"One line, macro doc."
macro m1(x)
    x
end

"""
Multiline, macro doc.
"""
macro m2(x)
    x
end

md"One line, macrostring doc."
t1(x) = x

md"""
Multiline, macrostring doc.
"""
t2(x) = x

module InnerModuleA

"One line, method documentation in an inner module."
function b(x)
    x
end

end

end

function test_docs(thing, category, docstring)
    result = @query thing
    @test first(result.categories[category].entries)[1].docs.data == docstring
end

function test_docs(thing, mod, category, docstring)
    result = query(thing, mod)
    @test first(result.categories[category].entries)[1].docs.data == docstring
end

test_docs(TestBareStrings.InnerModuleA.b, :method,
          "One line, method documentation in an inner module.")

test_docs(TestBareStrings.InnerModuleB.b, :method,
          "One line, method documentation in an inner module.")

@test TestBareStrings.InnerModuleB.__METADATA__.meta[:key] == "value"

test_docs(TestBareStrings.f1, :method, "One line, short method doc.")
test_docs(TestBareStrings.f2, :method, "One line, long method doc.")
test_docs(TestBareStrings.f3, :method,
          """
          Multiline, short method doc.
          """)
test_docs(TestBareStrings.f4, :method,
          """
          Multiline, long method doc.
          """)

test_docs(TestBareStrings.T1, :type, "One line, type doc.")
test_docs(TestBareStrings.T2, :type, "One line, abstract doc.")
test_docs(TestBareStrings.T3, :type,
          """
          Multiline, type doc.
          """)
test_docs(TestBareStrings.T4, :type,
          """
          Multiline, abstract doc.
          """)

test_docs(symbol("@m1"), TestBareStrings, :macro, "One line, macro doc.")
test_docs(symbol("@m2"), TestBareStrings, :macro,
          """
          Multiline, macro doc.
          """)

test_docs(TestBareStrings.t1, :method, "One line, macrostring doc.")
test_docs(TestBareStrings.t2, :method,
          """
          Multiline, macrostring doc.
          """)

for fn in [:g1, :g2, :g3, :j1, :j2, :j3]
    test_docs(getfield(TestBareStrings, fn), :method,
              "One line, loop generated doc for $(fn).")
end

for fn in [:h1, :h2, :h3, :k1, :k2, :k3]
    test_docs(getfield(TestBareStrings, fn), :method,
              """
              Multiline, loop generated doc for $(fn).
              """)
end

for i = 1:3

    test_docs(symbol("@n$(i)"), TestBareStrings, :macro,
              "One line, loop generated doc for @n$(i) macro.")

    test_docs(symbol("@o$(i)"), TestBareStrings, :macro,
              """
              Multiline, loop generated doc for @o$(i) macro.
              """)

    test_docs(getfield(TestBareStrings, symbol("S$(i)")), :type,
              "One line, loop generated doc for S$(i) type.")

    test_docs(getfield(TestBareStrings, symbol("R$(i)")), :type,
              """
              Multineline, loop generated doc for R$(i) type.
              """)

    test_docs(getfield(TestBareStrings, symbol("U$(i)")), :type,
              "One line, loop generated doc for U$(i) abstract type.")

    test_docs(getfield(TestBareStrings, symbol("V$(i)")), :type,
              """
              One line, loop generated doc for V$(i) abstract type.
              """)
end

test_docs(symbol("C1"), TestBareStrings, :global,
          "One line, constant doc.")

test_docs(symbol("C2"), TestBareStrings, :global,
          """
          Multiline, constant doc.
          """)

test_docs(symbol("C3"), TestBareStrings, :global,
          "One line, global doc.")

test_docs(symbol("C4"), TestBareStrings, :global,
          """
          Multiline, global doc.
          """)
