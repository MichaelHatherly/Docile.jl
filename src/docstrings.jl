# Check whether a given expression contains a dict.
isdictexpr(ex::Expr) = isexpr((isexpr(ex, :(=)) ? ex.args[1] : ex).args[2], :dict)
isdictexpr(other) = false

#=
Extract the mstr macro from an expression tuple. If the first argument
is not a multiline string then return current file and assume that the
docstring's metadata provides a file containing the docstring text
itself.
=#
function docstring(args)
    isdictexpr(args[1]) && return Expr(:macrocall, symbol("@__FILE__"))
    docs =
        if length(args) == 2
            args[1]
        else
            arg = args[end]
            arg.args[1] == :(..) ? arg.args[2] : arg.args[1].args[2]
        end
    @assert isa(docs, Expr)
    @assert docs.head == :macrocall
    @assert endswith(string(docs.args[1]), "mstr")
    docs
end

#=
Extract metadata from expression tuple and return it, or empty dict expression.
=#
function metadata(args)
    meta =
        if length(args) == 1 && !isdictexpr(args[1])
            :((Symbol => Any)[])
        else
            arg = args[end].args[2]
            arg.head == :dict ? arg : args[end].args[1].args[2]
        end
    @assert isa(meta, Expr)
    @assert meta.head in (:typed_dict, :dict)
    meta
end

#=
Extract the object being documented.
=#
function object(args)
    obj =
        let ex = args[end]
            if ex.args[1] == :(..)
                ex.args[end]
            else
                # rebuild the expression since `..` association broke it up.
                head = ex.args[1].args[end]
                tail = ex.args[end]
                Expr(:(=), head, tail)
            end
        end
    @assert isa(obj, Union(Symbol, Expr))
    obj
end

name(ex::Expr) = name(isa(ex.args[1], Bool) ? ex.args[2] : ex.args[1])
name(s::Symbol) = s

# Module indentifiers are handled directly in the @doc macro.
category(ex) =
    isfunction(ex) ? :function :
    ismethod(ex)   ? :method :
    isglobal(ex)   ? :global :
    ismacro(ex)    ? :macro :
    istype(ex)     ? :type :
    error("Cannot document that kind of object.\n$(obj)")

ismethod(ex) = isexpr(ex, [:function, :(=)]) && isexpr(ex.args[1], :call)

isfunction(ex) = false
isfunction(s::Symbol) = true

isglobal(ex) = isexpr(ex, [:const, :global, :(=)]) && !isexpr(ex.args[1], :call)

ismacro(ex) = isexpr(ex, :macro)
istype(ex) = isexpr(ex, [:type, :abstract, :typealias])

function lastmethod(fn)
    res = nothing
    for f in fn.env; res = f; end
    res
end

const METADATA = :__METADATA__

## macros –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

macro docstrings()
    esc(:($METADATA = Docile.Documentation(current_module())))
end

macro tex_mstr(text)
    triplequoted(text)
end

macro doc(args...)
    @assert 0 < length(args) < 3

    docs = docstring(args)
    meta = metadata(args)
    obj = object(args)

    cat = category(obj)
    qcat = Expr(:quote, cat)

    n = name(obj)

    var =
        if cat == :method
            :(Docile.lastmethod($obj))
        elseif cat == :macro
            t = Expr(:quote, symbol("@$n"))
            :($obj; $t)
        elseif cat == :global
            t = Expr(:quote, n)
            :($obj; $t)
        else # function or type (or module)
            :($obj; $n)
        end

    # better escaping needed
    quote
        res = $var
        ismod = $qcat == :function && !isa(res, Function) # handle module docs
        push!($METADATA, res, Docile.Entry{ismod ? :module : $qcat}($docs, $meta))
    end |> esc
end
