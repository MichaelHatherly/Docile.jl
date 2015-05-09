
"""
Setup macro-style documentation datastructures.
"""
macro init()
    META         = esc(:META)
    __METADATA__ = esc(:__DOCILE__METADATA__)
    quote
        if !isdefined(:META)
            const $META         = ObjectIdDict()
            const $__METADATA__ = ObjectIdDict()
            nothing
        end
    end
end

docs()     = current_module().META
metadata() = current_module().__DOCILE__METADATA__

meta(docstring; kwargs...) =
    (docstring, @compat(Dict{Symbol, Any}(kwargs)))

"""
Assign to docs to `n` and return a dictionary of keyword arguments.
"""
function data(n, docstr; kwargs...)
    dict = @compat(Dict{Symbol, Any}(kwargs))
    if isa(docstr, AbstractString)
        docs()[n] = docstr
    else
        docs()[n] = docstr[1]
        merge!(dict, docstr[2])
    end
    dict
end

"""
Get the symbolic name of an expression.
"""
nameof(x::Expr) = isa(x.args[1], Bool) ?
    nameof(x.args[2]) :
    nameof(x.args[1])

nameof(s::Symbol) = s

"""
Extract the line number and documented object expression from a block.
"""
unblock(x::Expr) = isexpr(x, :block) ?
    (x.args[1].args[1], x.args[2]) :
    error("Invalid '@doc' syntax.")

"""
Extract the docstring and expression to be documented from an `->` expression.
"""
unarrow(x::Expr) = isexpr(x, :(->)) ?
    (x.args[1], x.args[2]) :
    error("Missing '->' syntax.")

"""
Return the category of an object.
"""
lateguess(::Function) = :function
lateguess(::Module)   = :module
lateguess(::Any)      = error("Unknown category for '@doc'ed object.")

"""
Main documentation generation routine.
"""
function doc(expr::Expr, generic = false)

    # Extract docstring, object, and line number from the expression.
    docs, object = unarrow(expr)
    line, object = unblock(object)

    codesource = :(($(line), @__FILE__))

    name     = nameof(object)
    category = Collector.getcategory(object)

    # Check for correct '@doc+' usage.
    (generic && category != :method) && error("'@doc+' can only be applied to methods.")

    # Easier passing of arguments to subsequent function calls.
    packed = (
        docs,
        object,
        category,
        name,
        codesource
        )

    # Branch to category-specific expression generation.
    generic                           && return  genericdocs(packed)
    category == :symbol               && return symbolicdocs(packed)
    category == :method               && return   methoddocs(packed)
    category == :macro                && return    macrodocs(packed)
    category in (:global, :typealias) && return   globaldocs(packed)
    category in (:type, :abstract)    && return     typedocs(packed)

    error("Cannot use '@doc' on object.")
end

function genericdocs(packed)
    docs, object, category, name, codesource = packed
    d, o, n = map(esc, (docs, object, name))
    quote
        @init
        $(o)
        metadata()[$(n)] = data($(n), $(d);
            category   = $(Expr(:quote, :function)),
            codesource = $(codesource),
            code       = $(Expr(:quote, object))
            )
        $(n)
    end
end
function symbolicdocs(packed)
    docs, object, category, name, codesource = packed
    d, n = map(esc, (docs, name))
    quote
        @init
        metadata()[$(n)] = data($(n), $(d);
            category   = lateguess($(n)),
            codesource = $(codesource)
            )
        $(n)
    end
end
function methoddocs(packed)
    docs, object, category, name, codesource = packed
    d, o, n = map(esc, (docs, object, name))
    quote
        @init
        old = isdefined($(Expr(:quote, name))) ? Set{Method}(methods($(n))) : Set{Method}()
        $(o)
        for m in setdiff(Set{Method}(methods($(n))), old)
            metadata()[m] = data(m, $(d);
                category   = $(Expr(:quote, category)),
                codesource = $(codesource),
                code       = $(Expr(:quote, object))
                )
        end
        $(n)
    end
end
function macrodocs(packed)
    docs, object, category, name, codesource = packed
    name    = symbol(string("@", name))
    d, o, n = map(esc, (docs, object, name))
    quote
        @init
        $(o)
        metadata()[$(n)] = data($(n), $(d);
            category   = $(Expr(:quote, category)),
            codesource = $(codesource),
            code       = $(Expr(:quote, object)),
            signature  = $(Expr(:quote, object.args[1]))
            )
        $(n)
    end
end
function globaldocs(packed)
    docs, object, category, name, codesource = packed
    d, o, n = map(esc, (docs, object, name))
    quote
        @init
        $(o)
        metadata()[$(Expr(:quote, name))] = data(
            $(Expr(:quote, name)), $(d);
            category   = $(Expr(:quote, category)),
            codesource = $(codesource)
            )
        $(n)
    end
end
function typedocs(packed)
    docs, object, category, name, codesource = packed
    d, o, n = map(esc, (docs, object, name))
    quote
        @init
        $(o)
        metadata()[$(n)] = data($(n), $(d);
            category   = $(Expr(:quote, category)),
            codesource = $(codesource)
            )
        $(n)
    end
end

"""
Detect '@doc+' syntax in macro call.
"""
doc(s::Symbol, ex::Expr) = s ≡ :(+) ?
    doc(ex, true) :
    error("Invalid '@doc+' syntax.")

doc(other...) = throw(ArgumentError("Invalid '@doc' syntax."))

"""
Document an object.

    @doc " ... " ->
    f(x) = x

    @doc+ " ... " ->
    g(x) = x

"""
macro doc(ex) isexpr(ex, :call) ? doc(ex.args...) : doc(ex) end
