module Types

export Root, File, LazyDocs

type Root
    files :: Vector
    refs  :: Dict
    count :: Int

    function Root(files...)
        this = new([], Dict(), 0)
        this.files = [File(this, paths) for paths in files]
        this
    end

    # Mock root for use in LazyDocs.
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

    # Mock file for use in LazyDocs.
    File(m = current_module()) = new(Root(), m, "" => "")
end

type LazyDoc
    modname  :: Module
    blocks   :: Vector
    cached   :: Vector
    markdown :: Markdown.MD

    LazyDoc(text) = new(current_module(), parsebrackets(text), [])
end

end
