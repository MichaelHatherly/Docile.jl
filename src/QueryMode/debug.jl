
indent(n) = " "^4n

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Query, level = 0)
    println(io, "Query(")
    writemime(io, mime, x.term, 1)
    print(io, ")[$(x.index)]")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Text, level)
    println(io, indent(level), "Text(\"$(x.text)\")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: RegexTerm, level)
    println(indent(level), "RegexTerm($(x.regex))")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Object, level)
    println(indent(level), "Object(")
    println(indent(level + 1), "module: $(x.mod)")
    println(indent(level + 1), "symbol: $(x.symbol)")
    println(indent(level + 1), "object: $(x.object)")
    println(indent(level), ")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Metadata, level)
    println(indent(level), "Metadata(")
    if length(x.data) > 0
        width = maximum([length(string(k)) for k in keys(x.data)])
        for (k, v) in x.data
            print(io, indent(level + 1), rpad(string(k), width), " = ")
            println(io, isa(v, MatchAnyThing) ? "?" : repr(v))
        end
    end
    println(indent(level), ")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: TypeTerm, level)
    println(indent(level), "$(typeof(x).name.name)(")
    println(indent(level + 1), x.tuple)
    println(indent(level), ")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Union{And, Or}, level)
    println(indent(level), "$(typeof(x).name.name)(")
    writemime(io, mime, x.left, level + 1)
    writemime(io, mime, x.right, level + 1)
    println(io, indent(level), ")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Not, level)
    println(indent(level), "Not(")
    writemime(io, mime, x.term, level + 1)
    println(io, indent(level), ")")
end
