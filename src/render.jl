function writemime(io::IO, mime::MIME"text/plain", entries::Vector{(Any,Entry)})
    for (m, ent) in entries
        println(io, ">>>")
        println(io, AnsiColor.colorize(:blue, "\n • $(m)\n"; mode = "bold"))
        writemime(io, mime, ent)
    end
end

function writemime(io, ::MIME"text/plain", entry::Entry)
    println(io, entry.docs)
    # print metadata if any
    if !isempty(entry.meta)
        println(io, AnsiColor.colorize(:green, " • Details:\n"))
    end
    for (k, v) in entry.meta
        if isa(v, Vector)
            println(io, "\t ∘ ", k, ":")
            for line in v
                if isa(line, NTuple)
                    println(io, "\t\t", AnsiColor.colorize(:cyan, string(line[1])), ": ", line[2])
                else
                    println(io, "\t\t", string(line))
                end
            end
        else
            println(io, "\t ∘ ", k, ": ", v)
        end
        println(io)
    end
end
