@doc """
Full text search of docstrings available in the current REPL session.

**Examples:**

```julia
query("query")
```

+++
tags: [search, fulltext]
section: Queries and Searches
parameters:
    str: text to search for in all available documentation
""" ..
function query(str::String)
    results = (Method,Entry)[]
    for obj in names(Main)
        if isa(Main.(obj), Module) && isdefined(Main.(obj), METADATA)
            for (mt, ent) in Main.(obj).(METADATA).methods
                if searchmarkdown(ent.docstring, str)
                    push!(results, (mt, ent))
                end
            end
        end
    end
    results
end

function searchmarkdown(md::Markdown.Content, str::String)
    found = false
    for block in md.content
        found = found ||
            if :text in (ns = names(block);)
                contains(block.text, str)
            elseif :code in ns
                contains(block.code, str)
            elseif :content in ns
                searchmarkdown(block, str)
            end
    end
    found
end

@doc """
Search the module `m` for documentation on function `q` with
arguments `args`.

**Examples:**

```julia
query(Docile, query)
query(Docile, doctest, (Module,))
```

+++
section: Queries and Searches
parameters:
    m:    the target module to search through
    q:    generic function to search for
    args: optionally restrict returned methods to those with matching type
""" ..
function query(m::Module, q::Function, args = nothing)
    results = (Method,Entry)[]
    if isdefined(m, METADATA)
        mts = args == nothing ? methods(q) : methods(q, args)
        for mt in mts
            if haskey(m.(METADATA).methods, mt)
                push!(results, (mt, m.(METADATA).methods[mt]))
            end
        end
    else
        println("Module $(m) is not documented by Docile.")
    end
    isempty(results) && warn("No results found for $(m).$(q) with arguments $(args)")
    results
end

function query(m::Module, mt::Method)
    results = (Method,Entry)[]
    if isdefined(m, METADATA) && haskey(m.(METADATA).methods, mt)
        push!(results, (mt, m.(METADATA).methods[mt]))
    end
    isempty(results) && warn("No results found for $(m).$(mt)")
    results
end

macro query(q)
    mt = Expr(:macrocall, symbol("@which"), q)
    esc(:(Docile.query($(mt).func.code.module, $(mt))))
end
