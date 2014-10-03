Document objects in source code such as *functions*, *methods*, *macros*, *types*,
*globals*, and *modules*.

Takes a string as documentation and/or a `(Symbol => Any)` dictionary containing metadata.
Only one of these needs to be provided, but the docstring must appear first if both are
needed.

**Examples:**

```julia
@docstrings

@doc "A single line method docstring with no metadata." ->
f(x) = x

@doc "A single line macro docstring with some arbitrary metadata." {
    :author => "Author Name"
    } ->
macro g(x)
    x
end

@doc """
A longer docstring for a type in a triple quoted string with no metadata.
""" ->
type F
    # ...
end

@doc """
A triple quoted docstring for a global with metadata.
""" {
    :status => (:deprecated, v"0.1.0")
    } ->
const ABC = 1

value = "interpolated"

@doc """
Since docstrings are just normal strings values can be $(value) into
them from the surrounding scope or calculated, $(rand()), when the
module is loaded.
""" ->
immutable G
    # ...
end
```

### Documenting Functions and Methods

Adding documentation to a `Function` rather than a specific `Method` can
be achieved in two ways.

**Case 1**

Documentation may be added *after* the first definition of a method. In
the following example documentation is added to the method `f(x)`
and then to the generic function `f`.

```julia
@docstrings

@doc "Method specific documentation." ->
function f(x)
    x
end

@doc "Documentation for generic function `f`." -> f
```

*Note:* The `f` may be written directly after the `->` or on the subsequent line.

**Case 2**

There may only be generic documentation for a function and none that is
method-specific. In this case the generic documentation may be written
directly above one of the methods by using `@doc*`. The documentation
will then be associated with the `Function` object rather than that
particular `Method`.

```julia
@docstrings

@doc* "Generic documentation for this function." ->
function f(x)
    x
end
```

### Documentation Formatting and Interpolation

Currently the only supported format for docstrings is markdown as provided by the
Markdown.jl package.

By default all docstrings will be stored in `Docs{:md}` types. This default may be
changed (once other formats become available) using the `@docstring` macro metadata (see
[@docstrings](#@docstrings) for details).

Since `$` and `\` are not interpreted literally in strings, string macros `@md_str` and
`@md_mstr` are provided to make it easier to enter LaTeX equations in docstrings. The
[@md_str](#@md_str) entry provides details.
