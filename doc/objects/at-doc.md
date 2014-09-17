Document objects in source code such as *functions*, *methods*,
*macros*, *types*, *globals*, and *modules*.

Takes a string as documentation and/or a `(Symbol => Any)`
dictionary containing metadata. Only one needs to be provided, but the
docstring **must** appear first if both are needed.

**Examples:**

```julia
@docstrings

@doc """
Markdown formatted text appears here...
""" {
    :key => :value
    } ->
f(x) = x

@doc "A single line docstring with no metadata." ->
function g(x)
    x
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
