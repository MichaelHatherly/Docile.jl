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
    for f in fn.env
        res = f
    end
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

function docstar(star::Symbol, args...)
    star == :(*) ||  error("@doc: invalid modifier used: $(star)")
    true, args
end
docstar(args...) = (false, args)

function findsource(obj)
    loc = obj.args[1].args
    (loc[1], string(loc[2]))
end

const METADATA = :__METADATA__

@docref () -> REF_DOCSTRINGS
macro docstrings(files...)
    files = isempty(files) ? :([]) :
        :([abspath(joinpath(dirname(@__FILE__), f)) for f in $(files[1].args)])
    esc(:(const $METADATA = Docile.Documentation(current_module(), $files)))
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
    
    # Prebuilt expressions on single lines to avoid packing extra lines into destination module.
    if generic
        
        # Generic function docs attatched to a method definition.
        esc(:($obj; push!($METADATA, $n, Docile.Entry{:function}($source, $(data...)))))        
        
    elseif c == :method
        
        # Find all newly defined methods resulting from the current definition.
        before = gensym()
        oset = :($before = isdefined($qn) ? Set(methods($n)) : Set{Method}())
        nset = :(setdiff(Set(methods($n)), $before))
        
        esc(:($oset; $obj; push!($METADATA, $nset, Docile.Entry{:method}($source, $(data...)))))
        
    else
        
        # Category of entry.
        cat = c == :symbol ? :(Docile.lateguess(current_module(), $qn)) : :($qc)
        
        # Macros, types, globals, modules, functions (not attatched to a method)
        var = c in (:type, :symbol) ? :($n) : :($qn)
        esc(:($obj; push!($METADATA, $var, Docile.Entry{$cat}($source, $(data...)))))
        
    end
end
