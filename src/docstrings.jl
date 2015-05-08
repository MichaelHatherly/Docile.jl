for ext in [:md, :txt]
    @eval begin
        $(Expr(:toplevel, Expr(:export, symbol("@$(ext)_str"), symbol("@$(ext)_mstr"))))

        macro $(symbol("$(ext)_str"))(content, flags...)
            _build_expression(content, flags, $(Expr(:quote, ext)))
        end

        macro $(symbol("$(ext)_mstr"))(content, flags...)
            _build_expression(triplequoted(content), flags, $(Expr(:quote, ext)))
        end
    end
end

function _build_expression(content, flags, ext)
    Expr(:call, Expr(:curly, :Docs, Expr(:quote, ext)),
         "i" in flags ? interpolate(content) : content)
end

"""
Provide a file path to the contents of a docstring.

The path is relative to the current source code file where the macro is called
from. The docstring format is decided based on the file extension provided. For
files written in markdown the extension must be `.md`.

**Example:**

```julia_skip
file"../docs/foobar.md"
foobar(x) = 2x
```
"""
macro file_str(path)
    ext = symbol(strip(last(splitext(path)), '.'))
    Docs{ext}(File(joinpath(pwd(), path)))
end

"""
Add additional commentary to source code unrelated to any particular object.

**Example:**

```julia_skip
@comment \"\"\"
...
\"\"\"
```
"""
macro comment(text) text end

"""
Add additional metadata to a documented object.

`meta` takes arbitrary keyword arguments and stores them internally as a
`Dict{Symbol,Any}`. The optional `doc` argument defaults to an empty string if
not specified.

**Examples:**

The syntax previously used (in versions prior to `0.3.2`) was

```julia_skip
@doc "Documentation goes here..." [ :returns => (Int,) ] ->
foobar(x) = 2x + 1
```

This now becomes

```julia_skip
@doc meta("Documentation goes here...", returns = (Int,)) ->
foobar(x) = 2x + 1
```

Specifying an external file as documentation can be done in the following way:

```julia_skip
@doc meta(file = "../my/external/file.md") ->
foobar(x) = 2x + 1
```

**Note:** the `file` path is relative to the current source file.
"""
meta(doc = ""; args...) = (doc, Dict{Symbol, Any}(args))

export @doc_str, @doc_mstr

macro doc_str(text)
    text
end

macro doc_mstr(text)
    triplequoted(text)
end
