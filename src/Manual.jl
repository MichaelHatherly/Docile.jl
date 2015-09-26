"""
$(moduleheader())

Provides `@manual` for capturing external documentation.

$(exports())
"""
module Manual

using ..Utilities


export @manual
"""
    @manual(dir)

Embed external markdown files in a module as docstrings.

Usage:

    @manual("../doc/manual")

will read all files and folders from `"../doc/manual"` recursively and store
the contents of each file in a docstring matching the file's name.

    query> MyModule.manual.introduction

for the contents from `"../doc/manual/introduction.md"`.

    query> MyModule.manual

for the contents from `"../doc/manual/manual.md"`.
"""
macro manual(dir)
    root = Base.source_dir()
    if root === nothing
        warn("no source directory.")
    else
        dir = joinpath(root, dir)
        isdir(dir) ? esc(sections(dir)) : error("no directory found at '$dir'.")
    end
end

function sections(dir)
    ex =
        quote
            baremodule $(symbol(splitdir(dir)[end]))
                import Base: call, @doc
            end
        end
    body = ex.args[end].args[end].args
    for each in readdir(dir)
        if Base.isidentifier(splitext(each)[1])
            path = joinpath(dir, each)
            if isdir(path)
                push!(body, sections(path))
            else
                endswith(path, ".md") && push!(body, section(path, each))
            end
        end
    end
    ex.head = :toplevel
    ex
end

function section(path, name)
    dir, _ = splitdir(path)
    name = splitext(name)[1]
    expr = endswith(dir, name) ? :($(symbol(name))) : :(abstract $(symbol(name)))
    :(@doc $(Markdown.parse(readall(path))) $expr)
end

end
