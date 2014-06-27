
"""
Add new `Doc` to help system for the current Julia session.

* `block`: doc string and code block as a single string direct from source code.
* `file`: full path to the file where the doc string is located.
* `line`: line number of object (function, macro, etc.) being documented.
* `path`: the module(s) where the object in defined.

Note: The doc does not persist across different Julia sessions.
"""
function setdoc!(block::String, file::String, line::Int, path::Vector{Symbol})
    ex   = parse("begin $(block) end")
    docs = triplequoted(ex.args[2].args[end])
    code = ex.args[end]
    update_helpdb!(Doc(docs, file, line, path, code))
end

"""
Add new `Doc` to help system for the current Julia session.

* `doc`:  the doc string content.
* `file`: full file path to where the doc string is located.
* `line`: line number where the object being documented begins.
* `path`: module(s) where object is defined.
* `code`: an expression containing the object being documented.

Node: The doc does not persist across different Julia sessions.
"""
function setdoc!(doc::String, file::String, line::Int, path::Vector{Symbol}, code::Expr)
    update_helpdb!(Doc(doc, file, line, path, code))
end

# Partially from Base.Help.init_help().
function update_helpdb!(doc::Doc)
    Base.Help.init_help()
    mod, func, desc = helpdb(doc)
    if !isempty(mod)
        mfunc = mod * "." * func
        desc = Base.Help.decor_help_desc(func, mfunc, desc)
    else
        mfunc = func
    end
    if !haskey(Base.Help.FUNCTION_DICT, mfunc)
        Base.Help.FUNCTION_DICT[mfunc] = {}
    end
    push!(Base.Help.FUNCTION_DICT[mfunc], desc)
    if !haskey(Base.Help.MODULE_DICT, func)
        Base.Help.MODULE_DICT[func] = {}
    end
    if !in(mod, Base.Help.MODULE_DICT[func])
        push!(Base.Help.MODULE_DICT[func], mod)
    end
end
