
function process!(root :: Root)
    for file in root.files
        process!(file, root)
    end
    root
end

function process!(file :: File, root :: Root)
    for block in file.blocks
        process!(block, file, root)
    end
    file
end

function process!(block :: Tuple, file :: File, root :: Root)
    object = exec(block..., file)
    push!(file.cached, object)
    process!(object, file, root)
    block
end

function process!(lazydoc :: LazyDoc, file :: File, root :: Root)
    for block in lazydoc.blocks
        object = exec(block..., file)
        push!(lazydoc.cached, object)
        process!(object, file, root)
    end
    lazydoc
end

process!(other, file, root) = other
