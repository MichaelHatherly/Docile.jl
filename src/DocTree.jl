"""
$(moduleheader())

Abstract representation of a documentation tree.

$(exports())
"""
module DocTree

using ..Utilities

import ..Parser


"""
    Chunk

Chunks store a fragment of documentation from either a docstring or file together with a
name that describes how `Docile` handles the `Chunk`.

The field `.done` tells `expand!` whether the chunk should be processed or not. `true` for
process and `false` for skip.
"""
type Chunk
    name :: Symbol
    text :: UTF8String
    done :: Bool
end

"""
    Chunk(tuple)

Constructor that converts the raw tuples produced by `Parser.parsedocs` into `Chunk`s.
"""
Chunk(tuple :: Tuple{Symbol, Str}) = Chunk(tuple..., false)


"""
    Node

Stores a collection of `Chunk`s together with a `Module` reference that is used to resolve
cross-references and anchors.
"""
type Node
    chunks :: Vector{Chunk}
    modref :: Module

    Node(chunks) = new(chunks, current_module())
end

"""
    Node(str :: Str)

Constructor that converts a string into a `Node` object by extacting all `Chunks` from the
given string `str`.
"""
Node(str :: Str) = Node(map(Chunk, Parser.parsedocs(str)))

"""
    exprnode(str)

Returns an expression containing a `Node` constructor call for use by `Hooks.directives`.
"""
exprnode(str) = :(Main.Docile.DocTree.Node($str))


"""
    File

Represents a source file, it's contents in the form of `Node`s and the destination it will
be written to.
"""
type File
    nodes  :: Vector{Node}
    input  :: UTF8String
    output :: UTF8String
end

File(input, output) = File([Node(readall(input))], input, output)


"""
    Root

The root node in a documentation tree, storing all `File` objects, a cross-reference dict,
and the output mimetype the the files will be written as.
"""
type Root
    files   :: Vector{File}
    refs    :: ObjectIdDict
    mime    :: MIME
end

"""
    Root(mapping, mime)

Constructor that takes a vector of `(source, destination)` tuples representing files and
builds `File` objects to represent them.
"""
function Root(mapping, mime)
    files = [File(a, b) for (a, b) in mapping]
    Root(files, ObjectIdDict(), mime)
end

# Tree expansion.

"""
    checksizes(root, current)

Have any of the files expanded during the previous `expand!` call? `current` is a vector of
`Chunk` array lengths.
"""
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

"""
    define(f, n)

User-extensible directive system hook. Adds handling of user-defined directives.

```jl
define(:custom) do root, file, node, chunk
    # ...
    chunk
end
```

`define`s should return either a single `Chunk`, the original one or a modified one, or a
vector of `Chunk`s.
"""
define

"""
# Directives

*Syntax:*

    @<name>{...}

Where `<name>` contains only letters and `...` may contain any text. When no `<name` is
provided the default directive, `:docs` is used.

*Available directives:*

    @{...} or @docs{...}

The `:docs` directive replaces it's content with the docstrings of the objects in `...`.
Multiple objects may appear within a single `@{...}` and their docstrings are spliced back
in order.

    @esc{...}

Allows for writing a directive within a directive so that the inner one is not parsed and
expanded. Useful when writing documentation that mentions directives.

`:esc` is used to store all text found between directives in a file or docstring internally.

    @module{...}

Change the current module in which directives are evaluated, where the default is `Main`.

    @ref{...}

Cross-reference link to a docstring. Uses the same syntax as `:docs`, but only a single
object may appear in each `:ref`. If a `:ref` does not find a `:anchor` during expansion an
error is thrown.

    @anchor{...}

Related to `:ref`. `:anchor`s are the targets that `:ref` looks for during documentation
expansion. `:anchor`s must each refer to unique objects. An error is thrown when multiple
`:anchor`s correspond to the same object.

    @break{}

Adds a paragraph break in the final output.

    @code{...}

Run Julia code and display the final result. All code is run in a fresh `Module` to avoid
interference between different `:code` directives.

    @repl{...}

Simulate a Julia REPL environment. Each complete expression is presented with a `julia>`
before and it's result afterwards in the final output. ending an expression with `;` will
suppress the output.

"""
abstract DIRECTIVES # Mock type of documentation perposes.

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

"""
    getdocs(mod, expr)

Returns all documentation for an expression `expr` evaluated in module `mod` as a vector of
`Node`s.
"""
getdocs(mod, expr) = getdocs(eval(mod, :(@doc $expr)))

# Auto convert standard docs to directive docs.
getdocs(md :: Markdown.MD) = getdocs(Node(stringmime("text/markdown", md)))

getdocs(node :: Node)    = [node]
getdocs(nodes :: Vector) = nodes

"""
    extractdocs(node, doc, str)

Change the module evaluating `Module` and add an `:anchor` directive for the docstring
`doc`. Revert back the the orignal `Module` after the documentation has been spliced in.
"""
function extractdocs(node, doc :: Node, str)
    inner  = Chunk(:module, string(doc.modref), false)
    anchor = Chunk(:anchor, strip(str), false)
    outer  = Chunk(:module, string(node.modref), false)
    vcat(inner, anchor, doc.chunks, outer)
end
extractdocs(node, chunk :: Chunk, str) = chunk

end
