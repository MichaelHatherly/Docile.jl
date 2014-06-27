# builtin renderers for `Doc` subtypes

include("render/plain.jl")
include("render/helpdb.jl")
include("render/html.jl")

## common renderer helpers ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

fullsig(doc::Doc) = join([modulepath(doc), sig(doc)], ".")

sig(doc::Doc) = string(sig(code(doc)))
sig(doc::Doc{:macro}) = "@$(sig(code(doc)))"
sig(doc::Doc{:global}) = name(doc)

sig(ex::Expr) = isa(ex.args[1], Bool) ? ex.args[2] : ex.args[1]

name(doc::Doc) = string(name(code(doc)))
name(doc::Doc{:macro}) = "@$(name(code(doc)))"
name(doc::Doc{:global}) = stromg(name(code(doc)))

name(ex::Expr)  = name(sig(ex))
name(s::Symbol) = s

indent(doc::String, indent::Int = 3) =
    join([" "^indent * line for line in split(doc, "\n")], "\n")

escape(str) = replace(str, "<", "&lt;")
