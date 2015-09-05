
import Base.Docs: FuncDoc, TypeDoc, Binding
import Base.Markdown: MD, List, Paragraph, Bold, Code
import Base.REPL

immutable Results
    query :: Query
    data  :: Vector
end

function results(r :: Results)
    length(r.data) == 1                ? r.data[1][4] :
    0 < r.query.index ≤ length(r.data) ? r.data[r.query.index][4] :
    isempty(r.data)                    ? MD(Paragraph("No results found for query.")) :
    MD(
        Paragraph([
            Bold("Search Results."),
            " (To view an entry listed below append it's number to previous query.)"
        ]),
        List([Code(string(each[3])) for each in r.data], true),
    )
end

Base.writemime(io :: IO, mime :: MIME"text/plain", r :: Results) =
    writemime(io, mime, results(r))

Base.display(d :: REPL.REPLDisplay, r :: Results) =
    Markdown.term(REPL.outstream(d.repl), results(r))


metadata(m) = isdefined(m, :__META__) ? m.__META__ : ObjectIdDict()

"""
    exec(query)

Execute a `Query` object and return the `Result` containing docstrings found.
"""
function exec(query :: Query)
    rs = Results(query, [])
    for m in Base.Docs.modules, (k, v) in metadata(m)
        isa(k, ObjectIdDict) && continue
        getdoc!(rs, m, k, v)
    end
    sort!(rs.data, by = first, rev = true) # Sort results by score.
    rs
end

function getdoc!(rs :: Results, m, k, v :: Union{FuncDoc, TypeDoc})
    getdoc!(rs, m, k, v.main)
    for sig in v.order
        getdoc!(rs, score(rs, m, (k, sig), v.meta[sig]), m, makesig(k, v, sig), v.meta[sig])
    end
end

getdoc!(rs :: Results, m, k, v) = getdoc!(rs, score(rs, m, k, v), m, k, v)

getdoc!(rs :: Results, m, k, :: Nothing) = nothing
getdoc!(others...)                       = nothing

getdoc!(rs, s, m, k, v) = (s > 0 && push!(rs.data, (s, m, k, v)); nothing)

function makesig(k, v, sig :: Union)
    isempty(sig.types) && return string(k)
    _, index = findmax([length(x.parameters) for x in sig.types])
    singlesig(k, sig.types[index])
end
makesig(k, v, sig :: DataType) = singlesig(k, sig)

singlesig(k, sig) = string(k, "(", join(sig.parameters, ", "), ")")

# Query scoring.

score(rs :: Results, args...) = score(rs.query.term, args...)

# Text and Regex.

score(x :: Text, m, k, v)      = mdscore(x, v)
score(x :: RegexTerm, m, k, v) = mdscore(x, v)

mdscore(x, y :: Markdown.MD)         = mdscore(x, y.content)
mdscore(x, y :: Markdown.BlockQuote) = mdscore(x, y.content)
mdscore(x, y :: Markdown.Bold)       = mdscore(x, y.text)
mdscore(x, y :: Markdown.Code)       = mdscore(x, y.code)
mdscore(x, y :: Markdown.Header)     = mdscore(x, y.text)
mdscore(x, y :: Markdown.Italic)     = mdscore(x, y.text)
mdscore(x, y :: Markdown.LaTeX)      = mdscore(x, y.formula)
mdscore(x, y :: Markdown.Link)       = mdscore(x, y.text)
mdscore(x, y :: Markdown.Paragraph)  = mdscore(x, y.content)
mdscore(x, y :: Markdown.Table)      = mdscore(x, y.rows)

mdscore(x, y :: Vector) = (s = 0.0; for c in y; s += mdscore(x, c); end; s)

mdscore(x :: Text,      y :: AbstractString) = spliter(x.text, y)
mdscore(x :: RegexTerm, y :: AbstractString) = spliter(x.regex, y)

spliter(x, y) = (length(split(y, x))  - 1) / length(y)

mdscore(x, y) = 0.0

# Object.

score(x :: Object, m, k, v) = score(x, m, k) + (x.object == m ? 0.1 : 0.0)

score(x :: Object, m, k)            = x.object == k        ? 1.0 : 0.0
score(x :: Object, m, k :: Tuple)   = x.object == k[1]     ? 0.5 : 0.0
score(x :: Object, m, k :: Binding) = x.symbol == k.var    ? 0.5 : 0.0
score(x :: Object, m, k :: Module)  = matchmodule(x, m, k) ? 1.0 : 0.0

matchmodule(x, m, k) = x.mod == k && x.symbol == module_name(m)

# Metadata.

score(x :: Metadata, m, k, v :: Markdown.MD) = 0.0

# ArgumentTypes.

score(x :: ArgumentTypes, m, k :: Tuple, v) = x.tuple <: k[2] ? 1.0 : 0.0

# ReturnTypes.

score(x :: ReturnTypes, m, k :: Tuple{Function, Type}, v) = signatures(x, k...)

function signatures(x, f, t)
    out = 0.0
    isgeneric(f) && for m in methods(f, t)
        out += x.tuple <: returned(m) ? 1.0 : 0.0
    end
    out
end

function signatures(x, f, u :: Union)
    out = 0.0
    for sig in u.types
        out += signatures(x, f, sig)
    end
    out
end

returned(obj) = Core.Inference.typeinf(obj.func.code, obj.sig, Core.svec())[2]

# Logical Terms.
function score(x :: And, m, k, v)
    (left = score(x.left, m, k, v)) > 0 || return 0.0 # Shortcircuit.
    left * score(x.right, m, k, v)
end
score(x :: Or,  m, k, v) = score(x.left, m, k, v) + score(x.right, m, k, v)
score(x :: Not, m, k, v) = score(x.term, m, k, v) > 0.0 ? 0.0 : 1.0

# Skip everything else.
score(others...) = 0.0
