["Extraction of metadata from docstrings prior to formatting them."]

"""
Dispatch type for the `metamacro` function. `name` is a `Symbol`.
"""
immutable MetaMacro{name} end

"""
Shorthand syntax for defining `MetaMacro{<name>}`s as `META"<name>"`.

Example

    import Docile: Cache
    import Docile.Formats: metamacro, @META_str

    metamacro(::META"author", body, mod, obj) = isempty(body) ?
        Cache.findmeta(mod, obj, :author) :
        (Cache.getmeta(mod, obj)[:author = strip(body)]; "")

"""
macro META_str(str) :(MetaMacro{$(Expr(:quote, symbol(str)))}) end

# Extensions to this method are found in `Extendions` module.
metamacro(metamacro, body, mod, obj) = error("Undefined metamacro.")

"""
Run all 'metamacros' found in a raw docstring and return the resulting string.
"""
extractmeta!(text::AbstractString, mod::Module, obj) =
    extractmeta!(IOBuffer(text), mod, obj)

function extractmeta!(raw::IO, mod::Module, obj)
    out = IOBuffer()
    while !eof(raw)
        name, body = tryextract(raw)
        write(out, name == symbol("") ? read(raw, Char) :
                  metamacro(MetaMacro{name}(), body, mod, obj))
    end
    takebuf_string(out)
end

const METADATA_SKIP_PREFIX = ('\\', '!', '!')
const METADATA_PREFIX = ('!', '!')
const BRACKET_OPENER  = '('

"""
Try extract an embedded metadata entry name from buffer at current position.

Returns the empty symbol `symbol("")` when the current position is not the start
of an embedded metadata entry.
"""
function tryextract(io::IO)
    mark(io)
    if isprefix(io, METADATA_PREFIX) # The buffer must start with the prefix.
        name = IOBuffer()
        while !eof(io)
            c = read(io, Char)
            if c == BRACKET_OPENER
                unmark(io) # We don't need the mark anymore.
                return symbol(takebuf_array(name)), readbracketed(io)
            end
            isprint(c) && c != ' ' ? write(name, c) : break
        end
    end
    reset(io); mark(io)
    if isprefix(io, METADATA_SKIP_PREFIX)
        reset(io); unmark(io)
        read(io, Char)          # just read one char `\\` but do not validate the brackets
        return symbol(""), ""
    end
    # Give up trying to extract and return "nothing".
    reset(io); unmark(io)
    symbol(""), ""
end

"""
Does the buffer `io` begin with the given prefix chars?
"""
function isprefix(io::IO, chars)
    for c in chars
        !eof(io) && read(io, Char) == c || return false
    end
    true
end

"""
Extract to a string the text between matching brackets `(` and `)`.

Throws a `ParseError` when unmatched brackets are encountered.
"""
function readbracketed(io::IO)
    num = 1 # We've already read the opening bracket.
    out = IOBuffer()
    while !eof(io)
        c = read(io, Char)
        num += brackettype(c)
        num == 0 && return takebuf_string(out)
        write(out, c)
    end
    throw(ParseError("Unmatched brackets."))
end
brackettype(c::Char) = ifelse(c == '(', 1, ifelse(c == ')', -1, 0))
