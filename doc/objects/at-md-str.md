String macro to specify a docstring as a markdown-formatted `MarkdownDocstring` object.
This macro is useful when it is necessary to avoid Julia's string interpolation features,
such as writing LaTeX equations.

Once different formats are available for writing documentation these string macros will
allow the author to override the default docstring format specified by `@docstrings` if
they wish to write docstrings in several different formats in a single module.

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
