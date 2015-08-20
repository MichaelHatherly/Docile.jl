
"""
    directives(str, def)

Docsystem hook for executing ``@{...}`` directives embedded in docstrings.

**Usage:**

```julia
module MyModule

using Docile, Docile.Docs

addhook(directives)

"@{@time}"
f(x) = x

end
```
"""
directives(str, def) = :(Markdown.parse($(build("text/plain", str)))), def

"""
    typefielddocs(str, def)

Capture ``doc""``-style docstrings for type fields. Currently the base docsystem doesn't
detect them correctly.
"""
function typefielddocs(str, def)
    if isexpr(def, :type)
        for x in def.args[end].args
            if isexpr(x, :macrocall) && x.args[1] == symbol("@doc_str")
                x.head = :string
                shift!(x.args)
            end
        end
    end
    str, def
end

"""
    vecdoc(str, def)

A proof-of-concept "short-circuiting" docstring hook. ``nothing`` signals ``docm`` to
return ``def`` instead of passing the results onto the next hook or ``Base.Docs.docm``.
"""
function vecdoc(str, def)
    isexpr(def, :vect) || return str, def
    nothing, Expr(:block, [:(@doc($(esc(str)), $(esc(x)))) for x in def.args]...)
end
