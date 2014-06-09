## Docile Parser ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# Generate a helpdb from file.
function parsefile(file::String)
    open(file) do fn
        header = readline(fn)
        beginswith(header, "# ") || stop("Missing #.", header, file, 1)

        header = strip(header, Set("# \n"))
        isempty(header) && stop("Emtpy header given.", header, file, 1)

        entries = {}
        body    = IOBuffer()

        name = ""
        sig  = ""

        count = 0

        for (num,line) in enumerate(eachline(fn))
            if beginswith(line, "## ")
                count > 0 && addentry!(entries, header, name, sig, body)
                count += 1

                sig = strip(line, Set("# \n"))
                isempty(sig) && stop("Empty signature.", line, file, num)

                name = first(split(sig, r"(\(|{)", 2))
                isempty(name) && stop("Invalid entry name.", line, file, num)

            else
                write(body, line)
            end
        end
        count > 0 && addentry!(entries, header, name, sig, body)

        entries
    end
end

## Utils ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# Formatted error message for parser.
function stop(msg, line, file, num)
    warn("Stopping:")
    println("""
    File location: $(file):$(num)
    Line contents: $(line)
    """)
    error(msg)
end

function indenttext(input::IOBuffer; indent::Int = 3, skipbang = true)
    output = IOBuffer()
    for line in split(strip(takebuf_string(input)), "\n")
        if ismatch(r"\s*#!", line) && skipbang
            continue
        end
        write(output, string(" " ^ indent, line, "\n"))
    end
    output
end

# TODO: save using Markdown.jl
function addentry!(entries, header, name, sig, body)
    desc = takebuf_string(indenttext(body))
    sig = (header == name) ? header : string(header, ".", sig)
    doc = "$(sig)\n\n$(desc)\n"
    push!(entries, (header, name, doc))
end
