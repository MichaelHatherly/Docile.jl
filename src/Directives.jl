"""
    Directives
"""
module Directives

using Base.Meta, ..Utilities

export @directive_str, build, parsebracket


immutable Directive{name} end

macro directive_str(text) :(Directive{$(quot(symbol(text)))}) end

const DIRECTIVE_MARKER = r"^(\w+):\s*(?s)(.*)"

const DEFAULT = Ref{Directive}(directive"docs"())

withdefault(func :: Function, directive :: Symbol) =
    @with DEFAULT.x = Directive{directive}() func()

function getdirective(text)
    m = match(DIRECTIVE_MARKER, text)
    m ≡ nothing ? (DEFAULT.x, text) : (Directive{symbol(m[1])}(), m[2])
end


build(head :: Symbol, x) = Expr(head, build(x)...)

build(s :: Str)  = build(Expr(:string, s))
build(x :: Expr) = (v = []; for a in x.args buildeach(a, v) end; v)

function buildeach(s :: Str, out)
    for (n, part) in enumerate(split(s, r"{{|}}"))
        concat!(out, isodd(n) ? part : parsebracket(part))
    end
end
buildeach(x, out) = push!(out, x)


parsebracket(text :: AbstractString) = parsebracket(getdirective(text)...)
parsebracket{D}(:: Directive{D}, text) = error("Unknown directive: '$D'")

function parsebracket(:: directive"docs", text)
    out = []
    for each in split(text, "\n")
        s = strip(each)
        isempty(s) || push!(out, :(stringmime("text/markdown", @doc($(parse(s))))))
    end
    out
end

end
