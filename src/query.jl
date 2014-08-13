@doc """
Search the module `m` for documentation on function `q` with
arguments `args`.
+++
section: Queries and Searches
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
