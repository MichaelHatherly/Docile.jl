function documented(md = Main)
    modules = Set{Module}()
    for name in names(md, true)
        isdefined(md, name) || continue
        if isa((obj = getfield(md, name);), Module) && isdefined(obj, METADATA)
            push!(modules, obj)
            md == obj || union!(modules, documented(obj))
        end
    end
    modules
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

found(q, k, v)         = q == k
found(q::String, k, v) = contains(string(k), q) || searchmarkdown(v.docs, q)

category(ent::Entry) = typeof(ent).parameters[1]

@doc """

Search through loaded documentation for the query term `q`. `q` can be a
`String`, for full text searches, or an object such as a function or
type. When searching for macros, methods, or globals use the provided
`@query` macro instead.

The search can be restricted to particular modules by listing them
after the search term `q`.

**Examples:**

Display documentation for the `Docile` module.

```julia
query(Docile)
```

To display the documentation for a function, but not the associated
methods use `all = false` as a keyword to `query`.

```julia
query(query; all = false)
```

Querying can be narrowed down by providing a module or modules to
search through (defaults to searching `Main`).

`categories` further narrows down the types of results returned. Choices
for this are `:method`, `:global`, `:function`, `:macro`, `:module`, and
`:type`. These options are more useful when doing a text search rather
than an object search.

```julia
query("Examples", Docile; categories = [:method, :macro])
```

""" {
    :returns => (Vector{(Any, Entry)})
    } ->
function query(q, modules... = Main; categories = Symbol[], all = true)
    results = (Any, Entry)[]
    for m in union([documented(m) for m in modules]...)
        for (k, v) in getfield(m, METADATA).entries
            if (isempty(categories) || category(v) in categories) && found(q, k, v)
                push!(results, (k, v))

                # Show methods of a generic function. TODO: Optional?
                if isa(q, Function) && all
                    for mt in q.env
                        if haskey(getfield(m, METADATA).entries, mt)
                            push!(results, (mt, getfield(m, METADATA).entries[mt]))
                        end
                    end
                end
            end
        end
    end
    results
end

@doc "Search Docile-generated documentation." -> query

@doc """

Search through documentation of a particular package or globally.
`@query` supports every type of object that Docile can document with
`@doc`.

Qualifying searches with a module identifier narrows the searching to
only the specified module. When no module is provided every loaded module
containing docstrings is searched.

**Examples:**

In a similar way to `Base.@which` you can use `@query` to search for the
documentation of a method that would be called with the given arguments.

```julia
@query query("Examples", Main)
@query Docile.doctest(Docile)
```

Full text searching is provided and looks through all text and code in
docstrings, thus behaving in a similar way to `Base.apropos`. To specify
the module(s) to search through rather use the `query` method directly.

```julia
@query "Examples"
```

Generic functions and types are supported directly by `@query`. As with
method searches the module may be specified.

```julia
@query query
@query Docile.query
@query Docile.Summary
```

Globals require a prefix argument `global` to avoid conflicting with
function/type queries as see above.

```julia
@query global Docile.METADATA # this won't show anything
```

""" ->
macro query(q)
    Expr(:call, query, map(esc, parsequery(q))...)
end

function parsequery(q)
    if isa(q, Union(String, Symbol))
        (q,)
    elseif isexpr(q, :(.))
        (q, q.args[1])
    elseif isexpr(q, [:macrocall, :global])
        if isexpr((ex = q.args[1];), :(.))
            (Expr(:quote, ex.args[end].args[end]), ex.args[1])
        else
            (Expr(:quote, ex),)
        end
    elseif isexpr(q, :call)
        (Expr(:macrocall, symbol("@which"), q),)
    else
        error("can't recognise input.")
    end
end
