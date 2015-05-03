module Legacy

import ..Utilities


export @doc, @docstrings

macro doc(args...)
    # TODO
end
macro docstrings(args...)
    # TODO
end


export @doc_str, @doc_mstr

macro doc_str(text)
    text
end
macro doc_mstr(text)
    Base.triplequoted(text)
end


export @comment, @file_str

macro comment(text)
    [text]
end
macro file_str(text)
    text
end

end
