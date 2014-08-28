category(ex) =
    ismethod(ex) ? :method :
    ismacro(ex)  ? :macro  :
    istype(ex)   ? :type   :
    isglobal(ex) ? :global :
    issymbol(ex) ? :symbol :
    error("@doc: cannot document object:\n$(ex)")

ismethod(ex) = isexpr(ex, [:function, :(=)]) && isexpr(ex.args[1], :call)
isglobal(ex) = isexpr(ex, [:global, :const, :(=)]) && !isexpr(ex.args[1], :call)
istype(ex)   = isexpr(ex, [:type, :abstract, :typealias])
ismacro(ex)  = isexpr(ex, :macro)

# handle module/function as symbols at later stage of execution
issymbol(s::Symbol) = true
issymbol(ex) = false

guess(f::Function) = :function
guess(m::Module)   = :module
guess(unknown)     = error("@doc: cannot document a $(unknown)")

function lateguess(curmod, symb)
    isdefined(curmod, symb) || error("@doc: undefined object: $(symb)")
    guess(getfield(curmod, symb))
end

function lastmethod(fn)
    res = nothing
    for f in fn.env; res = f; end
    res
end

name(ex::Expr) = name(isa(ex.args[1], Bool) ? ex.args[2] : ex.args[1])
name(s::Symbol) = s

function separate(expr)
    data, obj = expr.args
    (data,), obj
end

function separate(docs, expr)
    meta, obj = expr.args
    (docs, meta), obj
end

const METADATA = :__METADATA__

## macros –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

macro tex_mstr(text)
    triplequoted(text)
end

macro docstrings()
    esc(:($METADATA = Docile.Documentation(current_module())))
end

macro doc(args...)
    isexpr(last(args), :(->)) || error("@doc: use `->` to separate docs/object:\n$(args)")

    # Separate out the documentation and metadata from the object.
    data, obj = separate(args...)

    # Find the category and name of an object. Build corresponding quoted expressions
    # for use in the `quote` returned. Macros names are prefixed by `@` here.
    c, n   = category(obj.args[2]), name(obj.args[2])
    qc, qn = Expr(:quote, c), Expr(:quote, c == :macro ? symbol("@$(n)") : n)

    # Capture the line and file.
    loc    = obj.args[1].args
    source = (loc[1], string(loc[2]))

    # Prebuilt expressions to avoid packing lines into the destination module.
    cat = :($qc == :symbol ? Docile.lateguess(current_module(), $qn) : $qc)
    var = :($qc == :method ? Docile.lastmethod($n) : $qc in (:type, :symbol) ? $n : $qn)

    esc(:($obj; push!($METADATA, $var, Docile.Entry{$cat}($source, $(data...)))))
end
