# What does the expression `ex` represent? Can it be documented? :symbol is used to
# resolve functions and modules is the calling module's context -- after `@doc` has
# returned.
object_category(ex) =
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

# Handle module/function as symbols at later stage.
issymbol(s::Symbol) = true
issymbol(ex) = false

# What does the symbol `symb` represent in the current module `curmod`.
function lateguess(curmod, symb)
    isdefined(curmod, symb) || error("@doc: undefined object: $(symb)")
    guess(getfield(curmod, symb))
end
guess(f::Function) = :function
guess(m::Module)   = :module
guess(unknown)     = error("@doc: cannot document a $(unknown)")

# Extract the symbol identifying an expression.
function name(ex::Expr)
    n = isa(ex.args[1], Bool)    ? ex.args[2] :           # types
        isexpr(ex.args[1], :(.)) ? ex.args[1].args[end] : # qualified names
        ex.args[1]
    name(n)
end
name(q::QuoteNode) = q.value
name(s::Symbol) = s

# Split the expressions passed to `@doc` into data and object. The docstring and metadata
# dict in the first tuple are the data, while the second returned value is the actual
# piece of code being documented.
function separate(expr)
    data, obj = expr.args
    (data,), obj
end
function separate(docs, expr)
    meta, obj = expr.args
    (docs, meta), obj
end

# Attaching metadata to the generic function rather than the specific method which the
# `@doc` is applied to.
function docstar(symb::Symbol, args...)
    (generic = symb == :(*);), generic ? args : (symb, args...)
end
docstar(args...) = (false, args)

# Returns the line number and filename of the documented object. This is based on the
# `LineNumberNode` provided by `->` and is sometimes a few lines out.
function findsource(obj)
    loc = obj.args[1].args
    (loc[1], string(loc[2]))
end

const METADATA = :__METADATA__

# Handle both kinds of config.
docstrings(; args...) = Dict{Symbol, Any}(args)
# TODO: deprecated.
function docstrings(d::Dict)
    Base.warn_once("Dict-based `@docstring` config is deprecated. Use keywords instead.")
    d
end

@docref () -> REF_DOCSTRINGS
macro docstrings(args...)
    :(const $(esc(METADATA)) = Documentation(current_module(), @__FILE__, Docile.docstrings($(args...))))
end

@docref () -> REF_DOC
macro doc(args...); doc(args...); end

function doc(args...)
    isexpr(last(args), :(->)) || error("@doc: use `->` to separate docs/object:\n$(args)")

    # Check for `@doc*` syntax and separate the args out.
    generic, args = docstar(args...)

    # Separate out the documentation and metadata (data) from the object (obj).
    data, obj = separate(args...)

    # Find the category and name of an object. Build corresponding quoted expressions
    # for use in the `quote` returned. Macros names are prefixed by `@` here.
    c, n   = object_category(obj.args[2]), name(obj.args[2])
    qc, qn = Expr(:quote, c), Expr(:quote, c == :macro ? symbol("@$(n)") : n)

    (generic && c != :method) && error("@doc: generic docstrings only allowed for methods.")

    # Capture the line and file.
    source = findsource(obj)

    autodocs = :(isdefined($(Expr(:quote, METADATA))) || @docstrings)

    # Prebuilt expressions on single lines to avoid packing extra lines into destination module.
    if generic

        # Generic function docs attached to a method definition.
        esc(:($autodocs; $obj; Docile.setmeta!(current_module(), $n, :function, $source, $(data...)); $n))

    elseif c == :method

        # Find all newly defined methods resulting from the current definition.
        before = gensym()
        oset = :($before = isdefined($qn) ? Set(methods($n)) : Set{Method}())
        nset = :(setdiff(Set(methods($n)), $before))

        esc(:($autodocs; $oset; $obj; Docile.setmeta!(current_module(), $nset, :method, $source, $(data...)); $n))

    else

        # Category of entry.
        cat = c == :symbol ? :(Docile.lateguess(current_module(), $qn)) : :($qc)

        # Macros, types, globals, modules, functions (not attached to a method)
        var = c in (:type, :symbol) ? :($n) : :($qn)
        esc(:($autodocs; $obj; Docile.setmeta!(current_module(), $var, $cat, $source, $(data...))))

    end
end
