module TypeFieldDocs

using Docile
addhook(Docile.Docs.typefielddocs)

"T"
type T
    doc"x"
    x
end

end

module VecDoc

using Docile
addhook(Docile.Docs.vecdoc)

function f end
function g end

"f, g"
[f, g]

end

module DocMeta

using Docile
addhook(Docile.Docs.docmeta)

macro wrapper(def)
    quote
        $(Expr(:meta, :doc, esc(def)))
    end
end

"T"
@wrapper type T end

end
