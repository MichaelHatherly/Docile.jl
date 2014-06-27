
extract(file::String) = extract!(Doc[], parsefile(file), file)

function extract!(docs::Vector{Doc}, expr::Expr, file::String,
                  path::Vector{Symbol} = Symbol[])
    for (n, ex) in enumerate(expr.args)
        if isdoc(ex)
            line = expr.args[n + 1].line
            str  = triplequoted(ex.args[end])
            obj  = expr.args[n + 2]
            push!(docs, Doc(str, file, line, path, obj))
        elseif isinclude(ex)
            # only handles direct string arguments to `include`
            fn = joinpath(dirname(file), ex.args[end])
            extract!(docs, parsefile(fn), fn, path)
        elseif ismodule(ex)
            extract!(docs, ex.args[end], file, [path, ex.args[2]])
        end
    end
    return docs
end

function parsefile(filename::String)
    buf = IOBuffer()
    print(buf, "begin ", readall(filename), " end")
    parse(bytestring(buf))
end
