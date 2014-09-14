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

end
```
