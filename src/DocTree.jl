"""
$(moduleheader())

$(exports())
"""
module DocTree

using ..Utilities

import ..Parser


type Chunk
    name :: Symbol
    text :: UTF8String
    done :: Bool
end

Chunk(tuple :: Tuple{Symbol, Str}) = Chunk(tuple..., false)


type Node
    chunks :: Vector{Chunk}
    modref :: Module

    Node(chunks) = new(chunks, current_module())
end

Node(str :: Str) = Node(map(Chunk, Parser.parsedocs(str)))

exprnode(str) = :(Main.Docile.DocTree.Node($str))


type File
    nodes  :: Vector{Node}
    input  :: UTF8String
    output :: UTF8String
end

File(input, output) = File([Node(readall(input))], input, output)


type Root
    files   :: Vector{File}
    refs    :: ObjectIdDict
    mime    :: MIME
end

function Root(mapping, mime)
    files = [File(a, b) for (a, b) in mapping]
    Root(files, ObjectIdDict(), mime)
end

# Tree expansion.

function checksizes(root, current)
    sizes = zeros(current)
    for (n, file) in enumerate(root.files)
        for node in file.nodes
            sizes[n] += length(node.chunks)
        end
    end
    all(sizes .== current), sizes
end

"""
    expand!(root :: Root)

Expand the doctree until it stops expanding or the iteration limit is reached.
"""
function expand!(root :: Root; limit = 5)
    sizes = zeros(length(root.files))
    for _ = 1:limit
        expand!(exec, root)
        done, sizes = checksizes(root, sizes)
        done && break
    end
    root
end

function expand!(f, root :: Root)
    for file in root.files
        expand!(f, root, file)
    end
end

function expand!(f, root :: Root, file :: File)
    for node in file.nodes
        expand!(f, root, file, node)
    end
end

function expand!(f, root :: Root, file :: File, node :: Node)
    chunks = []
    for chunk in node.chunks
        concat!(chunks, expand!(f, root, file, node, chunk))
    end
    node.chunks = chunks
end

function expand!(f, root :: Root, file :: File, node :: Node, chunk :: Chunk)
    chunk.done ? chunk : f(chunk.name, root, file, node, chunk)
end

# Directive cache.

let T = Dict()
    global define, exec
    define(f, n)  = haskey(T, n) ? error(":$n already defined.") : (T[n] = f)
    exec(n, x...) = haskey(T, n) ? T[n](x...) : error(":$n directive not defined.")
end

## Definitions.

define(:esc) do root, file, node, chunk
    chunk.done = true
    chunk
end

define(:module) do root, file, node, chunk
    result = getmodule(node.modref, chunk.text)
    isnull(result) ? chunk : (node.modref = get(result); chunk)
end

define(:ref) do root, file, node, chunk
    result = getobject(node.modref, chunk.text)
    if !isnull(result) && haskey(root.refs, get(result))
        object = get(result)
        dest   = root.refs[object]
        Chunk(
            chunk.name,
            "[`$(chunk.text)`]($dest#$object)",
            true
        )
    else
        chunk
    end
end

define(:anchor) do root, file, node, chunk
    result = getobject(node.modref, chunk.text)
    if !isnull(result)
        object = get(result)
        haskey(root.refs, object) && error("multiple anchors for $object.")
        root.refs[object] = file.output
        [
            Chunk(:break, "", true),
            Chunk(
                chunk.name,
                "<a href='$(chunk.text)'></a>",
                true
            ),
            Chunk(:break, "", true)
        ]
    else
        chunk
    end
end

define(:break) do root, file, node, chunk
    chunk
end

define(:code) do root, file, node, chunk
    Chunk(
        chunk.name,
        """
        **Example:**
        ```julia
        $(strip(chunk.text))
        ```
        *Output:*
        ```
        $(stringmime("text/plain", evalblock(Module(), chunk.text)))
        ```
        """,
        true
    )
end

define(:repl) do root, file, node, chunk
    m = Module()
    buf = IOBuffer()
    println(buf, "```")
    for (expr, str) in parseblock(chunk.text)
        str = strip(str)
        print(buf, "julia> ")
        for (n, line) in enumerate(split(str, "\n"))
            println(buf, line)
            n > 1 && print(buf, " "^7)
        end
        result = eval(m, expr)
        if !endswith(str, ";")
            writemime(buf, "text/plain", result)
            println(buf)
        end
        println(buf)
    end
    println(buf, "```")
    Chunk(
        chunk.name,
        takebuf_string(buf),
        true
    )
end

define(:docs) do root, file, node, chunk
    chunks = []
    for (expr, str) in parseblock(chunk.text), doc in getdocs(node.modref, expr)
        concat!(chunks, extractdocs(node, doc, str))
    end
    chunks
end


getdocs(mod, expr) = getdocs(eval(mod, :(@doc $expr)))

# Auto convert standard docs to directive docs.
getdocs(md :: Markdown.MD) = getdocs(Node(stringmime("text/markdown", md)))

getdocs(node :: Node)    = [node]
getdocs(nodes :: Vector) = nodes


function extractdocs(node, doc :: Node, str)
    inner  = Chunk(:module, string(doc.modref), false)
    anchor = Chunk(:anchor, strip(str), false)
    outer  = Chunk(:module, string(node.modref), false)
    vcat(inner, anchor, doc.chunks, outer)
end
extractdocs(node, chunk :: Chunk, str) = chunk

end
