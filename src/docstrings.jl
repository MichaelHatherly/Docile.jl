(..)(docstring::Expr, object::Expr) = (docstring, object)

macro docstrings()
    esc(:($METADATA = Docile.Documentation(current_module())))
end

function lastmethod(fn)
    res = nothing
    for f in fn.env; res = f; end
    res
end

macro doc(parts)
    if parts.head == :(=) # single line definitions
        obj = Expr(parts.head, parts.args[1].args[end], parts.args[2])
        entry = Entry(parts.args[1].args[2])
    else
        obj   = parts.args[3]
        entry = Entry(parts.args[2])
    end
    esc(:($METADATA.methods[Docile.lastmethod($obj)] = $entry))
end

const METADATA_SEPARATOR = "+++"

function Entry(mstr)
    (mstr.head == :macrocall && endswith(string(mstr.args[1]), "mstr")) ||
        error("Invalid docstring given.\n$(mstr)")

    txt   = chomp(triplequoted(mstr.args[end]))
    parts = map(strip, split(txt, METADATA_SEPARATOR))

    length(parts) == 2 || error("Docstrings require a `$(METADATA_SEPARATOR)`.\n$(txt)")

    docstring = Markdown.parse(utf8(parts[1]))
    metadata = isempty(parts[2]) ? Dict{String, Any}() : YAML.load(utf8(parts[2]))

    Entry(docstring, metadata)
end
