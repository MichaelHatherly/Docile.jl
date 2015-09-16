"""
$(moduleheader())

The directive syntax parser.

$(exports())
"""
module Parser

using ..Utilities

export parsedocs
"""
    parsedocs(text)

Parse a string `text` and return a vector of tuples representing the raw directive syntax.
"""
parsedocs(text :: AbstractString) = parsedocs(IOBuffer(text))

function parsedocs(buf :: IOBuffer)
    t = IOBuffer()
    out = []
    while !eof(buf)
        status, name = getname(buf)
        if status
            trywrite!(out, t)
            push!(out, (name, getbracket(buf)))
        else
            write(t, read(buf, Char))
        end
    end
    trywrite!(out, t)
end

"""
    getname(buf)

Check for `@<name>{` syntax from the start of the buffer `buf`. Returns the `<name>` as a
symbol if found. Also returns `true` or `false` to signal whether directive has been found.
"""
function getname(buf :: IOBuffer)
    mark(buf)
    if read(buf, Char) == '@'
        t = IOBuffer()
        while !eof(buf)
            isalpha(Char(Base.peek(buf))) || break
            write(t, read(buf, Char))
        end
        trypeek(buf, '{') || @goto rollback
        n = takebuf_string(t)
        true, n == "" ? :docs : symbol(n)
    else
        @label rollback
        reset(buf)
        false, :ignore
    end
end

"""
    getbracket(buf)

Returns the contents of a matching `{...}` pair as a string. Throws a `ParseError` when the
brackets do not match.
"""
function getbracket(buf :: IOBuffer)
    read(buf, Char) # Read the first `{` character.
    n, t = 1, IOBuffer()
    while !eof(buf)
        c = read(buf, Char)
        n += c == '{' ? 1 : c == '}' ? -1 : 0
        n > 0 ? write(t, c) : break
    end
    n == 0 ? takebuf_string(t) : throw(ParseError("unmatched brackets."))
end

"""
    trypeek(buffer, char)

Check if the next character in a buffer is `char`.
"""
trypeek(buffer, char) = !eof(buffer) && Base.peek(buffer) == char

"""
    trywrite!(out, buf)

Push the contents of `buf` to `out` if there is anything written to it.
"""
trywrite!(out, buf) = position(buf) == 0 ? out : push!(out, (:esc, takebuf_string(buf)))

end
