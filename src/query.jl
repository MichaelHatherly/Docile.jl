function documentedmodules(md = Main)
    modules = Module[]
    for obj in names(md)
        if isa(getfield(md, obj), Module) && isdefined(md.(obj), METADATA)
            push!(modules, md.(obj))
        end
    end
    modules
end

@doc """
Full text search of all docstrings curently available.

**Example:**

```julia
query("query")
```
""" {
    :tags       => ["search", "fulltext"],
    :section    => "Queries and Searches",
    :parameters => [
        (:str, "text to search for in all available documentation")
        ]
    } ->
function query(str::String)
    results = (Any,Entry)[]
    for md in documentedmodules()
        for (obj, ent) in getfield(md, METADATA).entries
            searchmarkdown(ent.docs, str) && push!(results, (obj, ent))
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
Search the module `m` for documentation on object `q`.

If `q` is not provided search for documentation related to the module
`m` itself.

**Examples:**

```julia
query(Docile)                     # docs for the module `Docile`
query(query)                      # function and method docs for `query`
query(query, Docile; all = false) # just the function docs in module `Docile`.
```
""" {
    :section => "Queries and Searches",
    :parameters => [
        (:m, "the target module to search through"),
        (:q, "optional object to search the module for"),
        (:all, "optional switch to show all methods associated with a function")
        ]
    } ->
function query(q, ms = documentedmodules(); all = true)
    results = (Any,Entry)[]
    for m in [ms]
        if haskey(getfield(m, METADATA).entries, q)
            push!(results, (q, getfield(m, METADATA).entries[q]))
        end
        if isa(q, Function) && all
            for mt in q.env
                if haskey(getfield(m, METADATA).entries, mt)
                    push!(results, (mt, getfield(m, METADATA).entries[mt]))
                end
            end
        end
    end
    results
end

@doc "Search for documentation in Docile-generated docstrings." -> query

@doc """
Search for documentation related to the method that would be called if
the expression `q` was evaluated. Behavour is similar to that of
`Base.@which`, but returns the documentation as well.

**Examples:**

```julia
@query doctest(Docile)
@query @query
```
""" {
    :section    => "Queries and Searches",
    :parameters => [
        (:q, "the expression to query")
        ]
    } ->
macro query(q)
    if isa(q, Symbol)
        Expr(:call, query, Expr(:quote, symbol(q)))
    elseif isa(q, Expr)
        if q.head == :macrocall
            Expr(:call, query, Expr(:quote, symbol("$(q.args[1])")))
        else
            mt = Expr(:macrocall, symbol("@which"), q)
            esc(:(query($(mt), $(mt).func.code.module, )))
        end
    end
end
