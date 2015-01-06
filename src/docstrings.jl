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

type File
    path::AbstractString
end

macro file_str(path)
    ext = symbol(strip(last(splitext(path)), '.'))
    Docs{ext}(File(joinpath(pwd(), path)))
end

"""
Add additional metadata to a documented object.

`meta` takes arbitary keyword arguments and stores them internally as a `Dict{Symbol,Any}`.
The optional `doc` argument defaults to an empty string if not specified.

**Examples:**

The syntax previously used (in versions prior to `0.3.2`) was

```julia
@doc "Documentation goes here..." [ :returns => (Int,) ] ->
foobar(x) = 2x + 1

```

This now becomes

```julia
@doc meta("Documentation goes here...", returns = (Int,)) ->
foobar(x) = 2x + 1
```

Specifying an external file as documentation can be done in the following way:

```julia
@doc meta(file = "../my/external/file.md") ->
foobar(x) = 2x + 1
```

**Note:** the `file` path is relative to the current source file.
"""
meta(doc = ""; args...) = (doc, Dict{Symbol, Any}(args))
