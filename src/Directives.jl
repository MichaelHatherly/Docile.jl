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

const DEFAULT_DIRECTIVE = Ref(:docs)

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
    @with DEFAULT_DIRECTIVE.x = directive func()

build(head :: Symbol, x) = Expr(head, build(x)...)

build(s :: Str)  = build(Expr(:string, s))
build(x :: Expr) = (v = []; for a in x.args buildeach(a, v) end; v)

buildeach(s :: Str, out) = concat!(out, parsebrackets(s))
buildeach(x, out) = push!(out, x)

# Parsing.

const DIRECTIVE = ('@', '{')

"""
    parsebrackets(text)

Extract ``@{...}`` from strings.
"""
parsebrackets(text) = parsebrackets(IOBuffer(text))

function parsebrackets(buf :: IOBuffer)
    out, temp = [], IOBuffer()
    while !eof(buf)
        if matchchars(buf, ('@', '{'))
            store!(out, temp)
            concat!(out, directive(getbracket(buf, temp)))
        else
            writechar!(temp, buf)
        end
    end
    store!(out, temp)
end

function getbracket(buf, temp, OPEN = '{', CLOSE = '}')
    n = 1
    while !eof(buf)
        c = read(buf, Char)
        n += c == OPEN ? 1 : c == CLOSE ? -1 : 0
        n > 0 ? write(temp, c) : break
    end
    n == 0 ? temp : throw(ParseError("Unmatched brackets."))
end

writechar!(into, from) = (c = read(from, Char); write(into, c); c)

"""
    store!(xs, buf)

When ``buf`` is not empty them extract the contents as a string and push it to ``xs``.
"""
store!(xs, buf) = position(buf) > 0 ? push!(xs, takebuf_string(buf)) : xs

"""
    matchchars(buf, chars)

Match a tuple of chars, ``chars``, beginning at the current buffer, ``buf``, position.
If the characters match then consume them and return ``true``, otherwise leave them
untouched and return ``false``.
"""
function matchchars(buf, chars)
    mark(buf)
    for c in chars
        if eof(buf) || read(buf, Char) ≠ c
            reset(buf)
            return false
        end
    end
    unmark(buf)
    true
end

function directive(buf :: IOBuffer)
    seek(buf, 0)
    t = IOBuffer()
    while !eof(buf)
        c = read(buf, Char)
        if c == ':'
            name = symbol(takebuf_string(t))
            text = readall(buf); takebuf_array(buf)
            Base.isidentifier(name) && return parsebracket(Directive{name}(), text)
            throw(ArgumentError("Invalid directive name '$(name)'."))
        end
        isalpha(c) ? write(t, c) : break
    end
    parsebracket(Directive{DEFAULT_DIRECTIVE.x}(), takebuf_string(buf))
end

"""
    parsebracket(directive :: Directive, text)

> User-extensible syntax hook.

Extending this function allows for handling of ``@{custom:...}`` syntax.

**Example:**

To define a directive that reverses the text it contains:

```julia
using Docile.Directives
Directives.parsebracket(:: directive"reverse", text) = reverse(text)
```

Now when

```md
@{reverse:hello world}
```

is parsed it will result in the following output:

```md
dlrow olleh
```
"""
function directive end

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
