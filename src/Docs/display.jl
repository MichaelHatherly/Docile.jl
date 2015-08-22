
function Base.writemime(io :: IO, :: MIME"text/plain", root :: Root)
    println(io, "Root(")
    println(io, " files")
    for file in root.files
        println(io, "  ", file.paths)
    end
    isempty(root.refs) || println(io, " refs")
    for (object, link) in root.refs
        println(io, "  ", object, " ", link)
    end
    print(io, ")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", file :: File)
    for each in file.cached
        writemime(io, mime, each)
    end
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", d :: LazyDoc)
    writemime(io, mime, genmarkdown(d, mime))
end

function Base.display(r :: Base.REPL.REPLDisplay, d :: LazyDoc)
    display(r, genmarkdown(d, "text/plain"))
end

function genmarkdown(d, mime)
    isdefined(d, :markdown) && return d.markdown
    isempty(d.cached) && process!(d, File(), Root())
    buf = IOBuffer()
    for each in d.cached
        writemime(buf, mime, each)
    end
    d.markdown = Markdown.parse(takebuf_string(buf))
end

function Base.Docs.catdoc(docs :: LazyDoc...)
    markdown = []
    for each in docs
        process!(each, File(), Root())
        push!(markdown, genmarkdown(each, MIME"text/plain"()))
    end
    Base.Docs.catdoc(markdown...)
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", d :: DOCS)
    d.file.paths == ("" => "") || println(io, "<a name='$(d.id)'></a>")
    writemime(io, mime, d.docs)
end

Base.writemime(io :: IO, :: MIME"text/plain", t :: TEXT) = print(io, t.text)

Base.writemime(io :: IO, :: MIME"text/plain", e :: ESC) = print(io, "@{", e.text, "}")

function Base.writemime(io :: IO, :: MIME"text/plain", ref :: REF)
    path, anchor = get(ref.refs, ref.object, (""=>"", 0))
    print(io, "[`", ref.text, "`](", path[2], "#", anchor, ")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", repl :: REPL)
    println(io, "```")
    for (line, result) in zip(repl.lines, repl.results)
        println(io, "julia> ", line)
        endswith(line, ";") || (writemime(io, mime, result); println(io))
        println(io)
    end
    print(io, "```")
end


function Base.writemime(io :: IO, mime :: MIME"text/plain", ex :: EXAMPLE)
    text =
    """
    ```
    $(ex.source)
    ```
    *Result*
    ```
    $(stringmime(mime, ex.result))
    ```
    """
    print(io, text)
end
