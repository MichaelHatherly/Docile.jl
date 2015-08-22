
# Directive cache.

let dir = Dict{Symbol, Base.Callable}()

    global define

    function define(f, n)
        haskey(dir, n) && error("'$n' already defined.")
        dir[n] = f
    end

    global exec

    function exec(name, args...)
        haskey(dir, name) || error("'$name' is not a directive.")
        dir[name](args...)
    end
end

# Default directives.

type DOCS
    object :: Any
    docs   :: Union{Markdown.MD, LazyDoc}
    file   :: File
    id     :: Int

    function DOCS(text, file)
        object = getobject(file.modname, text)
        docs   = getdocs(file.modname, text)
        process!(docs, file, file.root)
        refs = file.root.refs
        id   = file.root.count += 1
        haskey(refs, object) ?
            error("Duplicate docstring '$(text)' in file '$(file.paths[1])'.") :
            refs[object] = (file.paths, id)
        new(
            object,
            docs,
            file,
            id
        )
    end
end

define(DOCS, :docs)

type TEXT
    text :: ByteString
end

define((text, file) -> TEXT(text), :text)

type ESC
    text :: ByteString
end

define((text, file) -> ESC(text), :esc)

type REF
    text   :: ByteString
    object :: Any
    refs   :: Dict

    REF(text, file) = new(text, getobject(file.modname, text), file.root.refs)
end

define(REF, :ref)

type REPL
    mod     :: Module
    lines   :: Vector{ByteString}
    results :: Vector

    function REPL(text, file)
        mod = Module()
        lines, results = [], []
        for each in split(text, "\njulia> ")
            s = strip(each)
            isempty(s) && continue
            push!(lines, s)
            push!(results, evalblock(mod, s))
        end
        new(mod, lines, results)
    end
end

define(REPL, :repl)

type EXAMPLE
    mod    :: Module
    source :: ByteString
    result :: Any

    function EXAMPLE(text, file)
        mod = Module()
        result = evalblock(mod, text)
        new(mod, strip(text), result)
    end
end

define(EXAMPLE, :example)
