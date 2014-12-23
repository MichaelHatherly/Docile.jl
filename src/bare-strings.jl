using Base.Meta

export @document

const PKG  = :Docile
const META = :__METADATA__

macro document(args) wrapmodule!(checkargs(args)...) end

"Add documentation caching code to the given module."
function wrapmodule!(mexpr, opts)

    body = mexpr.args[end]

    # Hide variable from the module.
    includes = gensym()

    # Added immediately after a module's ``eval`` definitions.
    pre =
        quote
            # Maintain list of included files for this module.
            const $(includes) = UTF8String[]

            # Intercept all ``include`` calls to cache filenames.
            include = path -> $(PKG).cached_include($(includes), path)
        end
    splice!(body.args, 3:2, [Expr(:import, PKG), pre])

    # Added at the very end of the module.
    post =
        quote
            # Restore normal behaviour of ``include``.
            include = Base.include_from_node1

            # Store module's documentation.
            const $(META) = $(PKG).document(
                current_module(),
                @__FILE__,
                $(includes),
                $(opts))
        end
    push!(body.args, post)

    Expr(:toplevel, esc(mexpr))
end

"Build documentation object for the given ``modname``."
function document(
        modname  :: Module,
        root     :: AbstractString,
        included :: Vector{UTF8String},
        options  :: Dict{Symbol, Any}
        )

    ### TODO

end

"A modified version of ``include`` that caches the included file's path."
function cached_include(cache, path::AbstractString, prev = Base.source_path(nothing))
    path = prev ≡ nothing ? abspath(path) : joinpath(dirname(prev), path)
    push!(cache, path)
    Base.include_from_node1(path)
end

options(; args...) = Dict{Symbol, Any}(args)

qualified(s, pkg = PKG) = Expr(:(.), pkg, QuoteNode(symbol(s)))

"Extract module definition and ``options`` method call."
function checkargs(expr)
    use = """
     Correct usage:

        using __Docile__
        @document options(
            # Optional keyword arguments go here.
            ) ->

        module TargetModule

        # Module contents goes here.

        end
    """
    err = str -> (print("\n", str); println(use); throw(ArgumentError(str)))

    (islambda(expr) && length(expr.args) == 2) ||
        err("Incorrect arguments given to ``@document`` macro.")

    opts, ex = expr.args

    (iscall(opts) && opts.args[1] == :options) ||
        err("Missing ``options`` call.")

    opts.args[1] = qualified(opts.args[1]) # Qualify the ``options`` method call.

    (isblock(ex) && length(ex.args) == 2 && ismodule(ex.args[end])) ||
        err("Missing module definition.")

    ex.args[end], opts # Strip out module's surrounding block expression.
end

isblock(ex)  = isexpr(ex, :block)
ismodule(ex) = isexpr(ex, :module)
iscall(ex)   = isexpr(ex, :call)
islambda(ex) = isexpr(ex, :(->))
