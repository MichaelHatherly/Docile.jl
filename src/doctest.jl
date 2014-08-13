function doctest(io::IO, document::Documentation, verbose::Bool)
    print_with_color(:blue, io, "[DOCTEST] running on module $(document.modname).\n")
    for (method, entry) in document.methods
        println(io, " • [ENTRY] $(method)")
        for block in entry.docstring.content
            if isa(block, Markdown.Code) # block.language == :julia
                print_with_color(:purple, io, "  ∘ [EVAL]\n")
                success = true
                try
                    eval(document.modname, parse("let; $(block.code); end"))
                catch err
                    success = false
                    print_with_color(:red, io, "  - [FAILURE]\n")
                    println(io, "\n", block.code, "\n")
                    print_with_color(:red, io, string(err), "\n")
                end
                if success
                    verbose && print_with_color(:white, io, "\n", block.code, "\n\n")
                    print_with_color(:green, io, "  + [SUCCESS]\n")
                end
            end
        end
    end
end

doctest(io::IO, m::Module, verbose) =
    isdefined(m, METADATA) ? doctest(io, m.(METADATA), verbose) :
    println(io, "No docs found in module $(m).")

@doc """
Run documentation check on the given module `m`. Evaluates all markdown
code blocks in docstrings. `verbose` option displays code blocks while
testing.
+++
tags: [testing, code blocks]
""" ..
doctest(m::Module; verbose = false) = doctest(STDOUT, m, verbose)
