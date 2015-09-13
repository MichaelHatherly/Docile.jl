"""
$(moduleheader())

$(exports())
"""
module Hooks

import ..DocTree

using ..Utilities, Base.Meta

const HOOKS = S"#Docile.Hooks.HOOKS#"

hooks(m)  = @get m HOOKS Function[]
hooks!(m) = @get m HOOKS eval(m, :(const $HOOKS = Function[]))

export register!
"""
    register!(def)

Add a docsystem hook to be run whenever a docstring is found in the current module.

```julia
using Docile

register!(Hooks.directives)
```
"""
register!(def :: Function) = push!(hooks!(current_module()), def)

function docm(str, def)
    for f in hooks(current_module())
        exit, str, def = f(str, def)
        exit && return esc(def)
    end
    Base.Docs.docm(str, def)
end
docm(others...) = Base.Docs.docm(others...)

__init__() = Base.DocBootstrap.setexpand!(docm)


# Pre-defined hooks.

export track
"""
    track([t])

Debugging directive to track the raw values found by the docsystem.
"""
track(t = __trace__) = (s, d) -> (push!(t, (current_module(), s, d)); (false, s, d))

const __trace__ = []


const __DOC__ = S"#Docile.Hooks.__doc__#"

export @__doc__
doc"""
    @__doc__(ex)

Mark macro-generated expressions that accept documentation.

```julia
macro example(f)
    quote
        @__doc__ $(f)(x)       = 1
                 $(f)(x, y)    = 2
        @__doc__ $(f)(x, y, z) = 3
    end |> esc
end
```
"""
macro __doc__(ex) esc(Expr(:block, __DOC__)) end

export __doc__
"""
    __doc__(str, def)

Enable `@__doc__` capturing in the docsystem.
"""
__doc__(str, def) = __doc__!(str, macroexpand(def))

function __doc__!(str, def :: Expr)
    found = false
    if isexpr(def, :block) && length(def.args) == 2 && def.args[1] == __DOC__
        def.head = :macrocall
        def.args = [S"@doc", str, def.args[end]]
        found = true
    else
        for each in def.args
            exit, str, def = __doc__!(str, each)
            found |= exit
        end
    end
    found, str, def
end
__doc__!(str, def) = false, str, def


export directives
"""
    directives(str, def)

Enable directive syntax in docstrings.
"""
directives(str, def) = false, DocTree.exprnode(str), def


export doc!sig
"""
    doc!sig(str, def)

Generate and store the automatic header string for a documented expression in the
docstring-local variable `doc!sig`. It can be interpolated into the docstring as with any
normal variable.
"""
doc!sig(str, def) = false, buildsig(str, macroexpand(def)), def

buildsig(str, def) = buildsig(Head(def), str, def)

buildsig(str, def :: Symbol) = sigexpr(str, quot(def))

buildsig(:: H"const", str, def)              = sigexpr(str, quot(def.args[1].args[1]))
buildsig(:: H"function, =", str, def)        = sigexpr(str, quot(def.args[1]))
buildsig(:: H"type", str, def)               = sigexpr(str, quot(def.args[2]))
buildsig(:: H"abstract, bitstype", str, def) = sigexpr(str, quot(def))

# Fallback method.
buildsig(:: Head, str, def) = str

function sigexpr(str, sig)
    quote
        let doc!sig = $sig
            $(markdown(str))
        end
    end
end


export doc!args
"""
    doc!args(str, def)

Capture all documented method arguments and store in the docstring-local variable
`doc!args`, which can be spliced into the docstring.
"""
doc!args(str, def) = (false, buildargs(str, macroexpand(def))...)

buildargs(str, def) = buildargs(Head(def), str, def)

function buildargs(:: H"function, =", str, def)
    isexpr(def.args[1], :call) || return str, def
    out = extract_argdocs!(def.args[1])
    str =
        quote
            let doc!args = $(args2str)("Arguments", $(out))
                $(markdown(str))
            end
        end
    str, def
end
buildargs(:: Head, str, def) = str, def

function extract_argdocs!(ex :: Expr, out = [])
    args, out = Any[ex.args[1]], []
    for (n, a) in enumerate(ex.args[2:end])
        if isa(a, Str) || isexpr(a, :string)
            length(ex.args) > n && push!(out, ex.args[n + 2] => a)
        else
            push!(args, a)
        end
    end
    ex.args = args
    out
end

export doc!kwargs
"""
    doc!kwargs(str, def)

Capture all documented method keywords and store in the docstring-local variable
`doc!kwargs`, which can be spliced into the docstring.
"""
doc!kwargs(str, def) = (false, buildkwargs(str, macroexpand(def))...)

buildkwargs(str, def) = buildkwargs(Head(def), str, def)

function buildkwargs(:: H"function, =", str, def)
    isexpr(def.args[1], :call) || return str, def
    out = extract_kwargdocs!(def.args[1])
    str =
        quote
            let doc!kwargs = $(args2str)("Keywords", $(out))
                $(markdown(str))
            end
        end
    str, def
end
buildkwargs(:: Head, str, def) = str, def

function extract_kwargdocs!(ex :: Expr, out = [])
    if length(ex.args) > 1 && isexpr(ex.args[2], :parameters)
        ex = ex.args[2]
        params, out = [], []
        for (n, a) in enumerate(ex.args)
            if isa(a, Str) || isexpr(a, :string)
                length(ex.args) > n && push!(out, ex.args[n + 1] => a)
            else
                push!(params, a)
            end
        end
        ex.args = params
    end
    out
end

markdown(s :: Str) = s
markdown(x :: Expr) = isexpr(x, :string) ?
    :(Markdown.doc_str($x, @__FILE__, current_module())) : x

function args2str(title, dict)
    out = IOBuffer()
    println(out, "**$title:**", "\n")
    for (k, v) in dict
        println(out, "`", k, "`:", "\n")
        println(out, v, "\n")
    end
    println(out)
    takebuf_string(out)
end

end
