
import Base.Docs: FuncDoc, TypeDoc, Binding
import Base.Markdown: MD, List, Paragraph, Bold
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
        List([each[3] for each in r.data], true),
    )
end

Base.writemime(io :: IO, mime :: MIME"text/plain", r :: Results) =
    writemime(io, mime, results(r))

Base.display(d :: REPL.REPLDisplay, r :: Results) =
    Markdown.term(REPL.outstream(d.repl), results(r))

modules()   = Base.Docs.modules
metadata(m) = isdefined(m, :__META__) ? m.__META__ : ObjectIdDict()

function exec(query :: Query)
    results = Results(query, [])
    for mod in modules(), (k, v) in metadata(mod)
        isa(k, ObjectIdDict) && continue
        exec!(results, mod, k, v)
    end
    sort!(results.data, by = first, rev = true) # Sort results by score.
    results
end

function exec!(results :: Results, mod :: Module, k, v :: Union{FuncDoc, TypeDoc})
    exec!(results, mod, k, v.main)
    for each in v.order
        exec!(results, mod, each, v.meta[each])
    end
end

# TODO: fine tune this.
const MIN_SCORE = 0.0

function exec!(results :: Results, mod :: Module, k, v)
    score = getscore(results.query, mod, k, v)
    score > MIN_SCORE && push!(results.data, (score, mod, k, v))
end
exec!(results :: Results, mod :: Module, k, :: Nothing) = 0.0

getscore(q :: Query, args...) = getscore(q.term, args...)

# Text. TODO: improve performance and scoring.

function getscore(x :: Text, mod, k, v)
    text = stringmime("text/plain", v)
    (length(split(text, x.text)) - 1) / length(text)
end

function getscore(x :: RegexTerm, mod, k, v)
    text = stringmime("text/plain", v)
    (length(matchall(x.regex, text)) - 1) / length(text)
end

# Objects.

getscore(x :: Object, mod, k, v) = getscore(x, mod, k) + (x.object == mod ? 0.1 : 0.0)

getscore(x :: Object, mod, k :: Base.Callable) = k == x.object ? 1.0 : 0.0

function getscore(x :: Object, mod, k :: Method)
    isgeneric(x.object) || return 0.0
    x.object == getfield(k.func.code.module, k.func.code.name) ? 1.0 : 0.0
end

getscore(x :: Object, mod, k :: Binding) = x.symbol == k.var ? 1.0 : 0.0

getscore(x :: Object, mod, k :: Module) =
    (mod == k && x.symbol == module_name(mod)) ? 1.0 : 0.0

# No metadata is available for Markdown docs, requires Lazydocs, still to implement.
getscore(x :: Metadata, mod, k, v :: MD) = 0.0

# Type Terms. TODO: partial matching.

getscore(x :: ArgumentTypes, mod, k :: Method, v) =
    Base.typeseq(Tuple{x.tuple...}, k.sig) ? 1.0 : 0.0

getscore(x :: ReturnTypes, mod, k :: Method, v) = Base.typeseq(x.tuple, returned(k))

returned(obj) = Core.Inference.typeinf(obj.func.code, obj.sig, Core.svec())[2]

# Logical Terms.

getscore(x :: And, mod, k, v) = getscore(x.left, mod, k, v) * getscore(x.right, mod, k, v)

getscore(x :: Or, mod, k, v) = getscore(x.left, mod, k, v) + getscore(x.right, mod, k, v)

getscore(x :: Not, mod, k, v) = getscore(x.term, mod, k, v) == 0.0 ? 1.0 : 0.0

getscore(others...) = 0.0
