
@enum Status Passed Failed

immutable Result
    modname :: Module
    object  :: Any
    status  :: Status
    result  :: Any
    source  :: Code
end

immutable Results
    results :: Vector{Result}
    Results() = new(Result[])
end

passed(rs) = filter(r -> r.status == Passed, rs.results)
failed(rs) = filter(r -> r.status == Failed, rs.results)
update!(rs :: Results, r :: Result)  = push!(rs.results, r)
update!(rs :: Results, r :: Vector)  = for each in r update!(rs, each) end
update!(rs :: Results, r :: Nothing) = nothing

"""
    doctest(mod; submodules = true)

Test all Julia code blocks found in a module's docstrings.

By default all submodules are also checked. This can be disabled by setting the
``submodules`` keyword to ``false``.

``doctest`` returns a ``Results`` object that contains the results of all tests.

See also: ``details``.
"""
function doctest(mod :: Module, results = Results(); submodules = true)
    for m in (submodules ? Utilities.submodules(mod) : Set([mod]))
        for (obj, docs) in tryget(m, :__META__, ObjectIdDict())
            update!(results, doctest(mod, obj, docs))
        end
    end
    results
end

doctest(mod, obj :: ObjectIdDict, docs :: MD) = nothing

function doctest(mod, obj, docs :: TypeDoc)
    out = []
    push!(out, doctest(mod, obj, docs.main))
    for s in [:fields, :meta]
        for (k, v) in getfield(docs, s)
            push!(out, doctest(mod, (obj, k), v))
        end
    end
    out
end

function doctest(mod, obj, docs :: FuncDoc)
    out = []
    push!(out, doctest(mod, obj, docs.main))
    for (k, v) in docs.meta
        push!(out, doctest(mod, (obj, k), v))
    end
    out
end

function doctest(mod, obj, docs :: MD)
    out = []
    for each  in docs.content
        push!(out, runcode(mod, obj, each))
    end
    out
end

doctest(mod, obj, other) = nothing

function runcode(mod, obj, source :: Code)
    source.language == "julia" || return
    result, status = try
        sandbox = Module()
        importmod(sandbox, mod)
        evalblock(sandbox, source.code), Passed
    catch err
        err, Failed
    end
    Result(mod, obj, status, result, source)
end

runcode(mod, obj, other) = nothing

importmod(s, m) = eval(s, Expr(:toplevel, Expr(:using, fullname(m)...)))
