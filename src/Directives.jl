"""
    Directives
"""
module Directives

using Base.Meta, ..Utilities

export @directive_str, build, parsebracket, withdefault


immutable Directive{name} end

"""
    directive""

> Shorthand syntax for defining a directive.

```julia
parsebracket(:: directive"", text) = ...
```
"""
macro directive_str(text) :(Directive{$(quot(symbol(text)))}) end

const DIRECTIVE_MARKER = r"^(\w+)(:|\s*\n)((?s).*)$"

const DEFAULT = Ref{Directive}(directive"docs"())

"""
    withdefault(func, directive)

> Set the default directive to use within the call to ``func``.

**Usage:**

```julia
withdefault(:custom) do
    # ...
end
```
"""
withdefault(func :: Function, directive :: Symbol) =
    @with DEFAULT.x = Directive{directive}() func()

function getdirective(text)
    m = match(DIRECTIVE_MARKER, text)
    m ≡ nothing ? (DEFAULT.x, text) : (Directive{symbol(m[1])}(), m[3])
end


build(head :: Symbol, x) = Expr(head, build(x)...)

build(s :: Str)  = build(Expr(:string, s))
build(x :: Expr) = (v = []; for a in x.args buildeach(a, v) end; v)

function buildeach(s :: Str, out)
    # TODO parse these rather than use a regex
    # This regex still has some false positives
    # e.g. a line ending in Union{Int, MyType{Int}}
    for (n, part) in enumerate(split(s, r"^{{|\n{{|}}\s*(\n|$)"))
        concat!(out, isodd(n) ? part : parsebracket(part))
    end
end
buildeach(x, out) = push!(out, x)

"""
    parsebracket(directive :: Directive, text)

> User-extensible syntax hook.

Extending this function allows for handling of ``{{custom:...}}`` syntax.

**Example:**

To define a directive that reverses the text it contains:

```julia
using Docile.Directives
Directives.parsebracket(:: directive"reverse", text) = reverse(text)
```

Now when

```md
{{reverse:hello world}}
```

is parsed it will result in the following output:

```md
dlrow olleh
```
"""
function parsebracket end

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
