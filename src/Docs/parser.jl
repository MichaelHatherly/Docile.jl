
const DEFAULT_DIRECTIVE = Ref(:docs)
const DIRECTIVE_CHARS   = ('@', '{')

parsebrackets(s :: Str) = parsebrackets(IOBuffer(s))
parsebrackets(other)    = other

function parsebrackets(buf :: IOBuffer)
    out, temp = [], IOBuffer()
    while !eof(buf)
        if matchchars(buf, DIRECTIVE_CHARS)
            store!(out, temp)
            push!(out, directive(getbracket(buf, temp)))
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

store!(xs, buf) = position(buf) > 0 ? push!(xs, (:text, takebuf_string(buf))) : xs

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
            return name, text
        end
        isalnum(c) ? write(t, c) : break
    end
    DEFAULT_DIRECTIVE.x, takebuf_string(buf)
end
