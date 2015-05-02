# Search for things in modules.

"""
Return the set of all submodules of a given module `mod`.
"""
function submodules(mod::Module)
    out = Set([mod])
    for name in names(mod, true)
        if isdefined(mod, name)
            object = getfield(mod, name)
            validmodule(mod, object) && union!(out, submodules(object))
        end
    end
    out
end

validmodule(mod::Module, object::Module) = object ≠ mod && object ≠ Main
validmodule(::Module, other)             = false

"Path to Julia's base source code."
const BASE = joinpath(JULIA_HOME, "..", "..", "base")

"""
Which source files are known to be included in a module.

**Note:** files with only constants will not be detected.
"""
function includedfiles(mod::Module, candidates::Set)
    out = Set{UTF8String}()
    for name in names(mod, true)
        if isdefined(mod, name)
            object = getfield(mod, name)
            if isgeneric(object)
                for def in methods(object)
                    file = location(def)
                    file ∈ candidates && push!(out, file)
                end
            elseif isa(object, Function) && isdefined(object, :code)
                file = location(object)
                file ∈ candidates && push!(out, file)
            end
        end
    end
    out
end

"""
Path to definition of a julia object, only methods are searched for.
"""
location(object::Method) = expandpath(string(object.func.code.file))
location(func::Function) = expandpath(string(func.code.file))
location(other)          = ""

expandpath(path) = abspath(isabspath(path) ? path : joinpath(BASE, path))

"""
Is the file the root for a module `mod`. Check for `Expr(:module, ...)`.

**Note:** Assumes that all submodules have unique names.
"""
function isrootfile(mod::Symbol, parsed::Expr)
    result = false
    for arg in parsed.args
        result = isexpr(arg, :module) && arg.args[2] ≡ mod ?
            true : isrootfile(mod, arg)
        result && break
    end
    result
end
isrootfile(mod::Symbol, other) = false

function matching(pred::Function, root::AbstractString)
    out = Set{UTF8String}()
    for object in readdir(root)
        path = joinpath(root, object)
        pred(path)  && push!(out, path)
        isdir(path) && union!(out, matching(pred, path))
    end
    out
end
