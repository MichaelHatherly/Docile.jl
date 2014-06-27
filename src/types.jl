
"""
Documentation and metadata extracted from doc strings.
"""
type Doc{category}
    docs::String
    file::String
    line::Int
    modulepath::Vector{Symbol}
    code::Expr
end

function Doc(docs, file, line, modulepath, code)
    cat = category(code, file, line)
    Doc{cat}(docs, file, line, modulepath, code)
end

category{cat}(d::Doc{cat}) = cat

code(d::Doc) = d.code

docs(d::Doc) = d.docs

file(d::Doc) = d.file

line(d::Doc) = d.line

modulepath(d::Doc) = d.modulepath
modulepath(d::Doc{:module}) = [d.modulepath, name(code(d))]
