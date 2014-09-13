Document objects in source code, namely:

* functions
* methods
* macros
* types
* globals
* modules

Takes a multiline string as documentation and/or a `(Symbol => Any)`
dictionary containing metadata. Only one needs to be provided, but the
docstring **must** appear first if both are needed.

**Example:**

```julia
@docstrings

@doc """
Markdown formatted text appears here...
""" {
    :key => :value
    } ->
f(x) = x
```
