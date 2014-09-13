Docile is a [Julia](http://www.julialang.org) package documentation
system that provides a docstring macro, `@doc`, for documenting
arbitrary Julia objects and associating metadata with them.

### Installation

*Docile.jl* is in `METADATA` and can be installed via
`Pkg.add("Docile")`.

### Usage

The `@doc` macro can document *functions*, *globals*, *macros*,
*methods*, *modules*, and *types*. The syntax is the same for all cases.

**Example:**

```julia
module PackageName

using Docile
@docstrings # Call before any `@doc` uses. Creates module's `__METADATA__` object.

@doc """
Markdown formatted text appears here...

""" {
    # metadata section
    :section => "Main section",
    :tags    => ["foo", "bar", "baz"]
    # ... other (Symbol => Any) pairs
    } ->
function myfunc(x, y)
    # ...
end

@doc "A short docstring." ->
foo(x) = x

end
```

A `->` is required between the docstring/metadata and the object being
documented. It **must** appear on the same line as the docstring/metadata.

If no metadata is required for an object then the metadata section can be left out.

External files containing documentation can be linked to by adding a
`:file => "path"` to the metadata section of the `@doc` macro. The text
section of the macro is ignored in this case and can be left out. The
file path is taken to be relative to the source file.

**Example:**

```julia
@doc { :file => "../doc/manual.md" } -> Docile

```

The `@doc` macro requires at least a docstring or metadata section. The
docstring section always appears first if both are provided. Bare
`@doc`s are not permitted:

```julia
@doc -> illegal(x) = x

```

A `@tex_mstr` string macro is provided to avoid having to escape LaTeX
syntax in docstrings. Using standard multiline strings allows for
interpolating data into the string from the surrounding module in the
usual way.

Code generated via loops and `@eval` can also be documented. See the file
[loop-generated-docs.jl](https://github.com/MichaelHatherly/Docile.jl/blob/master/test/tests/loop-generated-docs.jl)
for an example of this.
