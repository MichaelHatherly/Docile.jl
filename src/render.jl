function writemime(io::IO, mime::MIME"text/plain", entries::Vector{(Method,Entry)})
    for (m, ent) in entries
        println(io, ">>>")
        println(io, AnsiColor.colorize(:blue, "\n • $(m)\n"; mode = "bold"))
        writemime(io, mime, ent)
    end
end

function writemime(io, ::MIME"text/plain", entry::Entry)
    println(io, entry.docstring)
    # print metadata if any
    if !isempty(entry.metadata)
        println(io, AnsiColor.colorize(:green, " • Metadata:\n"))
    end
    for (k, v) in entry.metadata
        println(io, "\t ∘ ", k, ": ", v)
    end
end
