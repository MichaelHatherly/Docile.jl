import Base: peek, is_id_char

# TODO: decide on handling of \\
function interpolate(content::AbstractString)
    out, str, tmp = Expr(:call, :string), IOBuffer(content), IOBuffer()
    while !eof(str)
        if (c = read(str, Char);) == '$'
            push!(out.args, takebuf_string(tmp), esc(parse_dollar(str)))
        else
            write(tmp, c)
        end
    end
    push!(out.args, takebuf_string(tmp))
    out
end

function parse_dollar(str::IO)
    eof(str) && error("stray dollar")
    out =
        if peek(str) == '('
            read(str, Char) # discard the opening bracket
            parse_brackets(str)
        else
            buf = IOBuffer()
            while !eof(str) && is_id_char(char(peek(str)))
                write(buf, read(str, Char))
            end
            buf
        end
    parse(takebuf_string(out))
end

function parse_brackets(str::IO)
    out, brackets = IOBuffer(), 1 # already counted the first bracket
    while !eof(str)
        c = read(str, Char)
        if c == '('
            brackets += 1
        elseif c == ')'
            (brackets -= 1) == 0 && return out
        end
        write(out, c)
    end
    brackets == 0 || throw(ParseError("unmatched brackets."))
    out
end
