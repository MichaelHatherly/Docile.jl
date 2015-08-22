
type Root
    files :: Vector
    refs  :: Dict
    count :: Int

    function Root(files...; process = true)
        this = new([], Dict(), 0)
        this.files = [File(this, paths) for paths in files]
        process && process!(this)
        this
    end

    Root() = new([], Dict(), 0)
end

type File
    root    :: Root
    modname :: Module
    paths   :: Pair
    blocks  :: Vector
    cached  :: Vector

    function File(root, paths)
        new(
            root,
            current_module(),
            paths,
            parsebrackets(readall(paths[1])),
            [],
        )
    end

    File(m = current_module()) = new(Root(), m, "" => "")
end

type LazyDoc
    modname  :: Module
    blocks   :: Vector
    cached   :: Vector
    markdown :: Markdown.MD

    LazyDoc(text :: Str) = new(current_module(), parsebrackets(text), [])
end
