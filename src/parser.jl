## Docile Parser ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

import Markdown: Header, Block, terminal_print, parse_file, Paragraph, Plain

function parsefile(file::String)
    md = parse_file(file)

    head = shift!(md.content)
    isa(head, Header{1}) || stop("Missing header.", head.text, file)

    header = strip(head.text)
    isempty(header) && stop("Blank header.", head.text, file)

    entries = {}
    entry = Block()
    name = ""

    for elem in md.content
        isa(elem, Header{1}) && stop("Too many # lines.", elem.text, file)

        if isa(elem, Header{2})
            addentry!(entries, entry, header, name)

            sig = strip(elem.text)
            isempty(sig) && stop("Empty signature.", elem.text, file)

            name = strip(first(split(sig, r"(\(|{)", 2)))
            isempty(name) && stop("Invalid entry name.", elem.text, file)

            sig = (head.text == name) ? name : string(header, ".", sig)

            # TODO: Style of signature? Match current style for now.
            push!(entry.content, Paragraph(Plain(sig)))
        else
            push!(entry.content, elem)
        end
    end
    addentry!(entries, entry, header, name) # Don't forget the last one!

    return entries
end

function addentry!(entries, entry, header, name)
    if !isempty(entry.content)
        doc = sprint(io -> terminal_print(io, entry, columns = 80))
        push!(entries, (header, name, doc))
        empty!(entry.content)
    end
end

function stop(msg, line, file)
    warn("Stopping:")
    print("""
    File: $(file)
    Line: $(line)
    """)
    error(msg)
end
