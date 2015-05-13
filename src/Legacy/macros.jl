
export @docstrings, @document

macro options(args...) :(options($(map(esc, args)...))) end
options(; args...) = @compat(Dict{Symbol, Any}(args))

macro docstrings(args...)
    ARGS = esc(:__DOCILE_ARGS__)
    quote
        const $(ARGS) = @options($(map(esc, args)...))
    end
end
macro document(args...)
    ARGS = esc(:__DOCILE_ARGS__)
    quote
        const $(ARGS) = @options($(map(esc, args)...))
    end
end


export @doc_str, @doc_mstr

macro doc_str(text)
    text
end
macro doc_mstr(text)
    Base.triplequoted(text)
end


export @comment, @file_str

"""
Deprecated macro for adding object-independent docstrings to a module.

Use the following syntax instead:

    ["..."]

!!set(status:deprecated)
"""
macro comment(text)
    [text]
end

"""
The text found in the file ``text`` is used as the docstring content.

Deprecated in favour of automatically using a file's content if the docstring
matches a file path.

!!set(status:deprecated)
"""
macro file_str(text)
    text
end
