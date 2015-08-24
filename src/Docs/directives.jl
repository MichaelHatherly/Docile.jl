
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

"""
Directives refer to the syntax ``@{...}`` which can be used to embed arbitrary user-defined
code and domain specific languages inside docstrings and external documentation read be
``makedocs``.

## Usage

Directives are called using the syntax ``@{<name>:<text>}`` where ``<name>`` is some valid
Julia identifier containing only letters and ``<text>`` is the content to be passed to the
directive. If no ``<name>`` is provided then the default directive, ``docs`` is called.

To enable directives inside docstrings ``addhook(directives)`` must be called at the start
of the module before any docstrings.
"""
abstract Directive

"""
### ``docs``

Retrieve documentation from the Julia help system and embed it in place of the directive.
The syntax is the same as that used in the REPL ``?`` mode. This is the default directive
and does not require the directive name, ``docs``, to be specified.

**Example:**

```
@{foobar}

@{docs:foobar}
```
"""
type DOCS <: Directive
    object :: Any
    docs   :: Union{Markdown.MD, LazyDoc}
    file   :: File
    id     :: Int

    function DOCS(expr, file)
        object = getobject(file.modname, expr)
        docs   = getdocs(file.modname, expr)
        process!(docs, file, file.root)
        refs = file.root.refs
        id   = file.root.count += 1
        haskey(refs, object) ?
            error("Duplicate docstring '$(expr)' in file '$(file.paths[1])'.") :
            refs[object] = (file.paths, id)
        new(
            object,
            docs,
            file,
            id
        )
    end
end

define(:docs) do text, file
    out = []
    cursor = 1
    while cursor < length(text)
        expr, cursor = parse(text, cursor)
        push!(out, DOCS(expr, file))
    end
    out
end

type TEXT <: Directive
    text :: ByteString
end

define((text, file) -> TEXT(text), :text)

"""
### ``esc``

Escape directive syntax.

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
type ESC <: Directive
    text :: ByteString
end

define((text, file) -> ESC(text), :esc)

"""
### ``ref``

Automatic cross referencing link to a ``docs`` directive. Uses the same ``?`` mode syntax
as ``docs`` directive does.

**Example:**

```
@{ref:foobar}

@{foobar}
```
"""
type REF <: Directive
    text   :: ByteString
    object :: Any
    refs   :: Dict

    REF(text, file) = new(text, getobject(file.modname, text), file.root.refs)
end

define(REF, :ref)

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
type REPL <: Directive
    mod     :: Module
    lines   :: Vector{ByteString}
    results :: Vector

    function REPL(text, file)
        mod = Module()
        lines, results = [], []
        for each in split(text, r"\n(julia)?> ")
            s = strip(each)
            isempty(s) && continue
            push!(lines, s)
            push!(results, evalblock(mod, s))
        end
        new(mod, lines, results)
    end
end

define(REPL, :repl)

"""
### ``example``

Run a code block and display it's result afterwards. A new module is used for each
``example`` block in the same way as for ``repl`` blocks.

```
@{example:
A = [x + y for x = 1:3, y = 2:4]
b = [1, 2, 4]
A \ b
}
```
"""
type EXAMPLE <: Directive
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
