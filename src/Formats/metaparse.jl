["Extraction of metadata from docstrings prior to formatting them."]

"""
Dispatch type for the `metamacro` function. `name` is a `Symbol`.

When ``raw == true`` the metamacro with identifier ``name`` with not behave as a
standard metamacro. Nesting will be disabled and must be implemented explicitly
using ``Docile.Formats.extractmeta!`` as follows:

    function Formats.metamacro(::META"name"raw, body, mod, obj)
        # ...
        body = Docile.Formats.extractmeta!(body, mod, obj)
        # ...
    end

"""
immutable MetaMacro{name, raw} end

immutable MetaMacroNameError <: Exception
    msg :: AbstractString
end

"""
Check that a `MetaMacro`'s `name` is a valid identifier.

Throws a `MetaMacroNameError` if the string `s` is not valid.
"""
validname(s::AbstractString) = Base.isidentifier(s) ? s :
    throw(MetaMacroNameError("'$(s)' is not a valid metamacro name."))

"""
Shorthand syntax for defining `MetaMacro{<name>}`s as `META"<name>"`.

Example

    import Docile: Cache
    import Docile.Formats: metamacro, @META_str

    metamacro(::META"author", body, mod, obj) = isempty(body) ?
        Cache.findmeta(mod, obj, :author) :
        (Cache.getmeta(mod, obj)[:author = strip(body)]; "")

By default metamacros are 'nestable', which means that an author may
write metamacros within metamacros. In some cases this may not be the
behaviour that is desired. Nesting can be disabled on a per-definition
basis by using the ``raw`` modifier:

    metamacro(::META"name"raw, body, mod, obj) = ...

"""
macro META_str(args...)
    name = symbol(args[1])
    raw  = length(args) == 2 && args[2] == "raw"
    :(MetaMacro{$(Expr(:quote, name)), $(raw)})
end

# Extensions to this method are found in `Extensions` module.
metamacro(::Union()) = error("Undefined metamacro.")

"""
Run all 'metamacros' found in a raw docstring and return the resulting string.
"""
extractmeta!(text::AbstractString, mod::Module, obj) =
    extractmeta!(IOBuffer(text), mod, obj)

function extractmeta!(raw::IO, mod::Module, obj)
    out = IOBuffer()
    while !eof(raw)
        name, body = tryextract(raw)
        result = name ≡ symbol("") ? read(raw, Char) : applymeta(name, body, mod, obj)
        write(out, result)
    end
    takebuf_string(out)
end

"""
Apply nesting to body of metamacro when defined otherwise treat as raw text.
"""
function applymeta(name, body, mod, obj)
    applicable(metamacro, (m = MetaMacro{name, false}();), body, mod, obj) &&
        return metamacro(m, extractmeta!(body, mod, obj), mod, obj)
    applicable(metamacro, (m = MetaMacro{name, true}();), body, mod, obj) &&
        return metamacro(m, body, mod, obj)
    error("Undefined metamacro: '!!$(name)(...)'.")
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
                return symbol(validname(takebuf_string(name))), readbracketed(io)
            end
            isgraph(c) ? write(name, c) : break
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
