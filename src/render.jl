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
        println(io, AnsiColor.colorize(:green, " • Details:\n"))
    end
    for (k, v) in entry.metadata
        if isa(v, Dict) # special case nested dict (1 level)
            println(io, "\t ∘ ", k, ":")
            for (a, b) in v
                println(io, "\t\t", AnsiColor.colorize(:cyan, string(a)), ": ", b)
            end
        else
            println(io, "\t ∘ ", k, ": ", v)
        end
        println(io)
    end
end
