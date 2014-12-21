#=

Bare Docstrings
===============

Plain strings/multiline-strings/string-macros that appear directly before a
documentable object are transformed from

    <<docstring>>
    <<object>>

into

    @doc <<docstring>> ->
    <<object>>

syntax using the ``@document`` macro. This macro can be used as follows:

    using Docile

    @document options(
        # Optional keyword arguments passed to ``@docstrings``.
        ) ->

    module ModuleName

    # Module's contents goes here.

    "Docstring for method ``foobar``."
    foobar(x) = x

    end

The mock-method ``options`` is used to pass keyword arguments to the
``@docstrings`` macro inside the targeted module ``ModuleName``. ``@document``
creates the following block expression inside of the targeted module:

    module ModuleName

    # >>> GENERATED
    using Docile
    @docstrings <<keyword arguments>>
    # <<< END GENERATED

    # rest of original module...

    end

``include`` calls are followed into their respective files and the previous
transformations mentioned will be applied. File and line numbers should be
preserved. Complex or non-standard uses of ``include`` will probably confuse
this macro. ``require``, ``reload``, ``import``, ``importall``, and ``using``
will not be followed and thus act as boundaries for the ``@document`` macro.

Uses of docstrings inside of ``@eval`` blocks might work.

=#

macro document(ex::Expr)
    # Error checks.
    check_at_document_expr(ex)
    opts, modexpr = ex.args
    check_options_expr(opts)
    check_module_expr(modexpr)

    # Expression rewriting
    out = manipulate_expr!(ex.args[2].args[1].args[2], modexpr.args[2])

    # Docile preamble.
    splice!(out.args[end].args, 3,
            [Expr(:using, :Docile),
             Expr(:macrocall, symbol("@docstrings"), opts.args[2:end]...)])

    Expr(:toplevel, esc(out))
end

function manipulate_expr!(file::Symbol, ex::Expr)
    args = copy(ex.args)
    out  = Expr(ex.head)
    while !isempty(args)
        arg = shift!(args)

        replace_include!(arg)
        insert_using!(arg)

        # Build ``@doc`` expression.
        if isa(arg, AbstractString) || isexpr(arg, :string) || isstringmacro(arg)
            tmp = Any[arg]
            while !isempty(args)
                arg = shift!(args)
                push!(tmp, arg)
                if isdocumentable(arg)
                    # Should have form: [<DOCSTRING>, <LINENODE>, <OBJECT>]
                    length(tmp) == 3 || error("Invalid docstring location.")

                    # Build the ``->``-style docstring syntax.
                    expr = :(@doc $(tmp[1]) -> $(tmp[3]))
                    # Replace line number node from ``->`` above with correct one.
                    expr.args[end].args[end].args[1].args = [tmp[2].args[1], file]
                    push!(out.args, expr)

                    empty!(tmp) # Avoid duplicating expressions.
                    break
                end
            end
            append!(out.args, tmp)
        else
            arg = manipulate_expr!(file, arg)
            push!(out.args, arg)
        end
    end
    out
end
manipulate_expr!(file::Symbol, other) = other # No-op for anything else.

function isstringmacro(ex)
    isexpr(ex, :macrocall) && ismatch(r"(_|m|_m)str$", string(ex.args[1]))
end

function isdocumentable(ex)
    ismethod(ex) || ismacro(ex) || istype(ex) || isglobal(ex) || issymbol(ex)
end

## Expression rewriting –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

function insert_using!(ex)
    if ismodule(ex)
        insert!(ex.args[end].args, 3, Expr(:using, :Docile))
    end
    ex
end

function replace_include!(ex)
    if isexpr(ex, :call) && ex.args[1] == :include
        ex.head = :macrocall
        ex.args[1] = Expr(:(.), :Docile, QuoteNode(symbol("@__include__")))
    end
    ex
end

macro subdoc(file, ex)
    isexpr(ex, :block) || throw(ArgumentError("Wrong expression given."))
    esc(manipulate_expr!(symbol(file), ex))
end

macro __include__(file)
    quote
        file = joinpath(dirname(@__FILE__), $(esc(file)))
        txt = "using Docile; Docile.@subdoc \"$(file)\" begin $(readall(file)) end"
        include_string(txt, file)
    end
end

## Error reporting ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

const USAGE = """
Correct usage:

    using Docile

    @document options(
        # optional keyword arguments
        ) ->

    module ModuleName

    # module contents goes here

    end
"""

function check_at_document_expr(ex)
    if isexpr(ex, :(->)) && length(ex.args) == 2
        return
    end
    error("Incorrect ``@document`` syntax. $(USAGE)")
end

function check_options_expr(ex)
    if isexpr(ex, :call) && ex.args[1] == :options
        return
    end
    error("Missing ``options`` call. $(USAGE)")
end

function check_module_expr(ex)
    if isexpr(ex, :block) && length(ex.args) == 2 && isexpr(ex.args[end], :module)
        return
    end
    error("Missing module definition. $(USAGE)")
end
