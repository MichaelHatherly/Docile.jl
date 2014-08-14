function doctest(io::IO, document::Documentation, verbose::Bool)
    print_with_color(:blue, io, "[DOCTEST] running on module $(document.modname).\n")
    for (obj, entry) in document.docs
        println(io, " • [ENTRY] $(obj)")
        for block in entry.docs.content
            if isa(block, Markdown.Code) # block.language == :julia
                print_with_color(:purple, io, "  ∘ [EVAL]\n")
                success = true
                try
                    if endswith(block.code, "\n")
                        print_with_color(:blue, io, "  ~ [SKIPPED]\n")
                        continue
                    end
                    eval(document.modname, parse("let\n$(block.code)\nend"))
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
Test all code blocks in the docstrings in a module `m`.

Run `doctest(Docile)` to see some sample output produced by this
function.
""" [
    :tags => ["testing", "code blocks"],
    :parameters => [
        (:m, "the module to test"),
        (:verbose, "optional switch to view detailed output of each test")
        ]
    ] ..
doctest(m::Module; verbose = false) = doctest(STDOUT, m, verbose)
