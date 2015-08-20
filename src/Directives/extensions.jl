
"""
# Directives

Directives refer to the syntax ``@{...}`` which can be used to embed arbitrary
user-defined code and domain specific languages inside docstrings and external documentation
read be ``makedocs``.

## Usage

Directives are called using the syntax ``@{<name>:<text>}`` where ``<name>`` is some
valid Julia identifier containing only letters and ``<text>`` is the content to be passed to
the directive. If no ``<name>`` is provided then the default directive, ``docs`` is called.

To enable directives inside docstrings ``addhook(Docile.Docs.directives)`` must be called at
the start of the module before any docstrings.

## Available Directives

"""
function directive end

directive{D}(:: Directive{D}, text) = throw(DirectiveError("Unknown directive '$D'."))

immutable Escape
    text :: UTF8String
end

Base.writemime(io :: IO, :: MIME"text/plain", esc :: Escape) = print(io, esc.text)

"""
### ``esc``

Escape a directive.

**Example:**

```
@{esc:foobar:
...
}
```

will result in

```
@{foobar:
...
}
```
"""
directive(:: D"esc", text) = :(Docile.Directives.Escape($(string("@{", text, "}"))))

# Documentation.

immutable Documentation
    docs :: Vector
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", d :: Documentation)
    for doc in d.docs
        writemime(io, mime, doc)
    end
end

"""
### ``docs``

Retrieve documentation from the Julia help system and embed it in place of the directive.
The syntax is the same as that used in the REPL ``?`` mode.

**Example:**

```
@{foobar}
```

Multiple docstrings can be embedded with a single directive by separating each query with a
newline.

```
@{
    foo
    bar
    baz
}
```
"""
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

"""
### ``repl``

Simulate a Julia REPL session within a docstring. A new module is defined for each ``repl``
block so that variables do not leak between them. Lines ending with ``;`` will not display
their output.

```
@{repl:
julia> a = 1;
julia> b = 2
julia> a + b
}
```
"""
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

"""
### ``example``

Run a code block and display it's result afterwards. A new module is used for each
``example`` block in the same way as for ``repl`` blocks.

```
@{example:
A = [x + y for x = 1:3, y = 2:4]
b = [1, 2, 4]
A \\ b
}
```
"""
directive(:: D"example", text) = :(Docile.Directives.Example(Module(), $(strip(text))))
