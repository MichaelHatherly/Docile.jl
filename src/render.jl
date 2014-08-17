function writemime(io::IO, mime::MIME"text/plain", entries::Vector{(Any,Entry)})
    for (m, ent) in entries
        println(io, ">>>")
        println(io, AnsiColor.colorize(:blue, "\n • $(m)\n"; mode = "bold"))
        writemime(io, mime, ent)
    end
end

function writemime(io::IO, ::MIME"text/plain", entry::Entry)
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

## html –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

const DEFAULT_STYLE = readall(joinpath(Pkg.dir("Docile"), "src", "style.css"))

function tags(fn::Function, io::IO, tag, attrs = "")
    println(io, "<", tag, isempty(attrs) ? "" : " ", attrs, ">")
    fn()
    println(io, "</", tag, ">")
end

function wrap(io::IO, tag, text, attrs="")
    print(io, "<", tag, isempty(attrs) ? "" : " ", attrs, ">")
    print(io, text, "</", tag, ">")
end

function writemime(io::IO, mime::MIME"text/html", entries::Vector{(Any,Entry)};
                   style = DEFAULT_STYLE)
    println(io, "<!doctype html>")
    tags(io, "head") do
        println(io, "<meta charset='utf-8'>")
        tags(io, "style") do
            println(io, style)
        end
    end
    tags(io, "body") do
        tags(io, "div", "class='entries'") do
            map(each -> writemime(io, mime, each), entries)
        end
    end
end

function writemime{T}(io::IO, mime::MIME"text/html", entry::(Any,Entry{T}))
    obj, ent = entry
    tags(io, "div", "class='entry'") do
        tags(io, "div", "class='header'") do
            wrap(io, "div", string("[", T, "]"), "class='category'")
            isa(obj, Method) ? writemime(io, mime, obj) : println(io, obj)
        end
        isempty(ent.meta) || tags(io, "div", "class='metadata'") do
            tags(io, "table") do
                for k in sort!(collect(keys(ent.meta)))
                    tags(io, "tr") do
                        wrap(io, "td", k, "class='key'")
                        tags(io, "td", "class='value'") do
                            writemime(io, mime, MetaContainer{k}(ent.meta[k]))
                        end
                    end
                end
            end
        end
        isempty(ent.docs.content) || tags(io, "div", "class='description'") do
            writemime(io, mime, ent.docs)
        end
    end
end

writemime(io::IO, ::MIME"text/html", mc::MetaContainer) = print(io, mc.content)

function writemime(io::IO, ::MIME"text/html",
                   mc::Union(MetaContainer{:parameters},
                             MetaContainer{:fields}))
    tags(io, "ul") do
        for (param, desc) in mc.content
            tags(io, "li") do
                wrap(io, "code", param)
                println(io, ": ", desc)
            end
        end
    end
end

function writemime(io::IO, ::MIME"text/html", mc::MetaContainer{:tags})
    print(io, join(mc.content, ", "))
end
