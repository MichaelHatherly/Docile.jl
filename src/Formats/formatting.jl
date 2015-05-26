abstract AbstractFormatter

immutable PlaintextFormatter <: AbstractFormatter end
immutable MarkdownFormatter  <: AbstractFormatter end

immutable Format{F <: AbstractFormatter} end

"""
Parsing hook for docstring parsing.

Example:

    import Docile.Formats, Markdown
    const (fmt, md) = (Docile.Formats, Markdown)

    fmt.parsedocs(::fmt.Format{fmt.MarkdownFormatter}, raw, mod, obj) = md.parse(raw)

When registering a package the format is then provided to `PackageData`.

Arguments:

- `raw`: Unparsed docstring extracted from source code.
- `mod`: Module where the docstring and object are defined.
- `obj`: Object that the docstring is associated with.

"""
parsedocs(::Format, raw, mod, obj) = raw
