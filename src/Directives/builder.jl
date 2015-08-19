
immutable Directive{name} end

macro D_str(text) :(Directive{$(quot(symbol(text)))}) end

const DEFAULT_DIRECTIVE = Ref(:docs)

build(mime, x)  = :(Docile.Directives.tostring($(mime), $(build(x))))
build(s :: Str) = build(Expr(:string, s))

function build(x :: Expr)
    out = Expr(:vcat)
    for arg in x.args
        concat!(out.args, parsebrackets(arg))
    end
    out
end

withdefault(func :: Function, directive :: Symbol) =
    @with DEFAULT_DIRECTIVE.x = directive func()

function tostring(mime, args)
    buf = IOBuffer()
    for arg in args
        writer(buf, mime, arg)
    end
    takebuf_string(buf)
end
tostring(mime, args...) = tostring(mime, args)

writer(io, mime, x)        = writemime(io, mime, x)
writer(io, mime, s :: Str) = print(io, s)
