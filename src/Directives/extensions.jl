
directive{D}(:: Directive{D}, text) = throw(DirectiveError("Unknown directive '$D'."))

# Documentation.

immutable Documentation
    docs :: Vector
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", d :: Documentation)
    for doc in d.docs
        writemime(io, mime, doc)
    end
end

function directive(:: D"docs", text)
    out = Expr(:vcat)
    for each in split(text, "\n")
        s = strip(each)
        isempty(s) || push!(out.args, :(@doc($(parse(s)))))
    end
    :(Docile.Directives.Documentation($(out)))
end

# REPL. Currently WIP.

immutable REPL
    modname :: Module
    lines   :: Vector
    results :: Vector

    function REPL(modname, lines)
        results = [evalblock(modname, line) for line in lines]
        new(modname, lines, results)
    end
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", r :: REPL)
    println(io, "```")
    for (line, result) in zip(r.lines, r.results)
        println(io, "julia> ", line)
        endswith(line, ";") || writemime(io, mime, result)
        println(io, "\n")
    end
    println(io, "```")
end

function directive(:: D"repl", text)
    out = Expr(:vcat)
    for each in split(text, "julia>")
        s = strip(each)
        isempty(s) || push!(out.args, s)
    end
    :(Docile.Directives.REPL(Module(), $(out)))
end

# Example.

immutable Example
    modname :: Module
    source  :: UTF8String
    result  :: Any

    Example(modname, source) = new(modname, source, evalblock(modname, source))
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", ex :: Example)
    output =
    """
    ```julia
    $(ex.source)
    ```
    **>>>**
    ```
    \e[37m
    $(stringmime(mime, ex.result))
    ```
    """
    print(io, output)
end

directive(:: D"example", text) = :(Docile.Directives.Example(Module(), $(strip(text))))
