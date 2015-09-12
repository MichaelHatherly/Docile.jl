"""
$(moduleheader())

$(exports())
"""
module Utilities

using Base.Meta

export Str
"""
    Str
"""
typealias Str AbstractString

export tryget
"""
    tryget(mod, field, default)

Returns the value bound to `field` in module `mod` or `default` if not found.
"""
tryget(mod, field, default) = isdefined(mod, field) ? getfield(mod, field) : default

export exports
"""
    exports()

Markdown formatted string containg a list of all exported symbols in a module.
"""
function exports(mod = current_module())
    symbols = filter(x -> x != module_name(mod), names(current_module()))
    isempty(symbols) ? "" :
    """
    **Exported Names:**

    $(join(["- `$n`" for n in symbols], "\n"))
    """
end

export moduleheader
"""
    moduleheader()

Returns a string containing a markdown formatted `Module` docstring header.
"""
moduleheader() = "    $(current_module()) :: Module"

export @get
"""
    @get(where, what, default)

Do `default` if `what` is not defined in `where` otherwise get `what` from `where`.
"""
macro get(where, what, default)
    esc(:(isdefined($where, $what) ? getfield($where, $what) : $default))
end

export @S_str
"""
    @S_str(text)

Shorthand syntax for defining symbols that are not valid identifiers.
"""
macro S_str(text) quot(symbol(text)) end

export submodules
"""
    submodules(mod)

Returns a set of all submodules of `Module` `mod`.
"""
function submodules(mod :: Module, out = Set())
    push!(out, mod)
    for name in names(mod, true)
        if isdefined(mod, name)
            object = getfield(mod, name)
            validmodule(mod, object) && submodules(object, out)
        end
    end
    out
end

validmodule(a :: Module, b :: Module) = b ≠ a && b ≠ Main
validmodule(a, b) = false

export files
"""
    files(cond, root)

Returns a set of all files from `root` that match `cond`.
"""
function files(cond, root, out = Set(); recursive = true)
    for f in readdir(root)
        f = joinpath(root, f)
        isdir(f)  && recursive && files(cond, f, out)
        isfile(f) && cond(f)   && push!(out, f)
    end
    out
end

export evalblock
"""
    evalblock(modname, block)

Evaluate the string `block` within the module `modname` and return the final value.
"""
function evalblock(modname, block)
    result = nothing
    for (expr, text) in parseblock(block)
        result = eval(modname, expr)
    end
    result
end

export parseblock
"""
    parseblock(block)

Returns a vector of all complete expressions and their original substrings found in `block`.
"""
function parseblock(block)
    result = []
    cursor = 1
    while cursor < length(block)
        expr, next_cursor = parse(block, cursor)
        push!(result, (expr, block[cursor:next_cursor-1]))
        cursor = next_cursor
    end
    result
end

"""
    @object(ex)

Return the object/binding that an expression represents.
"""
macro object(ex)
    if isexpr(ex, :call)
        name = esc(Base.Docs.namify(ex.args[1]))
        if any(x -> isexpr(x, :(::)), ex.args)
            :(methods($(name), $(esc(Base.Docs.signature(ex))))[end])
        else
            :(@which($(esc(ex))))
        end
    elseif Base.Docs.isvar(ex)
        :(Base.Docs.@var($(esc(ex))))
    else
        esc(ex)
    end
end

export getobject
"""
    getobject(mod, text)

Try to get the object found in `text` within module `mod`. Returns a `Nullable` if it fails.
"""
function getobject(mod, text)
    try
        Nullable{Any}(eval(mod, :(Main.Docile.Utilities.@object($(parse(text))))))
    catch
        Nullable{Any}()
    end
end

export getmodule
"""
    getmodule(mod, text)

Try to get the `Module` object in `text`. Returns a `Nullable{Module}` if it fails.
"""
function getmodule(mod, text)
    try
        Nullable{Module}(eval(mod, parse(text)))
    catch
        Nullable{Module}()
    end
end

export concat!
"""
    concat!(xs, x)

Append or push depending on the object being added to a vector. For flattening nested lists.
"""
function concat! end

concat!(xs, x) = push!(xs, x)
concat!(xs, ys :: Vector) = append!(xs, ys)

export msg
"""
    msg(text, cond)

Conditionally display a message.
"""
msg(text, cond) = (cond && info(text); nothing)

end

using .Utilities
