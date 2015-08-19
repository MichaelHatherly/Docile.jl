
"""
    makedocs()

> Generate markdown documentation from templated files.

**Keyword Arguments:**

- ``source = "src"``, directory to collect markdown files from.
- ``build = "build"``, destination directory for output files.
- ``clean = false``, should the build directory be deleted before building?

**Usage:**

Import ``Docile`` and the modules that should be documented. Then call ``makedocs``.

```jl
using Docile, MyModule

makedocs(
    source = "source-directory",
    build  = "build-directory",
    clean  = true,
)
```
"""
function makedocs(;
    source = "src",
    build  = "build",
    clean  = false,
    )
    cd(Base.source_dir()) do
        clean && isdir(build) && rm(build, recursive = true)
        input = files(x -> endswith(x, ".md"), source)
        width = maximum(map(length, input))
        for each in input
            output = joinpath(build, relpath(each, source))
            mkpath(dirname(output))
            message(each, output, width)
            loadfile(each, output)
        end
    end
end

message(a, b, w) = println("Building: $(rpad(string("'", a, "'"), w + 2)) --> '$(b)'")
