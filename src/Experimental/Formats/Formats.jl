module Formats

export Format, parsedocs

abstract AbstractFormatter

immutable PlaintextFormatter <: AbstractFormatter end

immutable Format{F <: AbstractFormatter} end

"""
Parsing hook for docstring parsing.

Example:

    import Docile.Formats, Markdown
    const (fmt, md) = (Docile.Formats, Markdown)

    immutable MarkdownFormatter <: fmt.AbstractFormatter end

    fmt.parsedocs(::fmt.Format{MarkdownFormatter}, raw) = md.parse(raw)

When registering a package the format is then provided to `PackageData`.

Arguments:

- `raw`: Unparsed docstring extracted from source code.
- `obj`: Object that the docstring is associated with.
- `mod`: Module where the docstring and object are defined.

"""
parsedocs(::Format, raw, obj, mod) = raw

end
