String macro to specify a docstring as markdown-formatted.

**Example:**

```julia
@docstrings

@doc md"Markdown formatted docstring." ->
f(x) = x
```

To use interpolation append an `i` to the docstring:

```julia
@docstrings

format = "Markdown"

@doc md"$(format) formatted docstring."i ->
f(x) = x
```
