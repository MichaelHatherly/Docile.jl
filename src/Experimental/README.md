# Docile Experiment

A rough sketch of future Docile with external documentation features.

```jl
include("DocileExperimental.jl")

# Register a package by specifying a root module and file. Use `PlaintextFormatter`.
# The module to be registered must already been imported with `import` or `using`.
DocileExperimental.Cache.register!(
    DocileExperimental,
    "/home/mike/.julia/v0.4/Docile/src/Experimental/DocileExperimental.jl";
    format = DocileExperimental.Formats.PlaintextFormatter
)

# Get the raw docstrings from the `Cache` module.
DocileExperimental.Cache.getraw(DocileExperimental.Cache)

# Parse all docstrings in the `Formats` module.
DocileExperimental.Cache.parse!(DocileExperimental.Formats)

# Get the parsed docstrings from the `Collector` module.
# Since `PlaintextFormatter` is a simple passthrough the output is the same as above.
DocileExperimental.Cache.getparsed(DocileExperimental.Collector)
```

## Differences

Able to document a module without being imported into it. This allows a package
to be documented with a single action, `register!`.

No `Entry` objects. `category` is defined by a `metadata` field per object.

`Formats` is used to define custom parsing of raw docstrings. User-extensible.

`Comment` and associated `@comment` is replaced with `Aside` and the syntax:

```jl
["This docstring doesn't belong to an object."]
```

`Aside` source location points to the top of the string. Normal docstrings still
point to the actual definition below the docstring.

`@file_str` is replaced by implicit file including. If a docstring matches a
file relative to the source file then it is read in and replaces the docstring
contents.

Removal of `loopdocs`.

## Roadmap

Write the `Interface` module to match current Docile, hopefully avoiding breaking changes.

Write a `@doc` macro that hooks into the new interfaces.

Finalise and polish current modules.

Replace `Docile` with `DocileExperimental`.
