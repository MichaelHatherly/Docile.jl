# For running tests in a "clean" environment.
module Sandbox end

function doctest(io::IO, document::Documentation, verbose::Bool)
    # Import the module being tested into the sandbox.
    eval(Sandbox, Expr(:toplevel, Expr(:using, symbol("$(document.modname)"))))

    print_with_color(:blue, io, "[DOCTEST] running on module $(document.modname).\n")
    for (obj, entry) in document.entries
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
                    eval(Sandbox, parse("let\n$(block.code)\nend"))
                catch err
                    success = false
                    print_with_color(:red, io, "  - [FAILURE]\n")
                    println(io, "\n", block.code, "\n")
                    print_with_color(:red, io, string(err), "\n\n")
                end
                if success
                    print_with_color(:green, io, "  + [SUCCESS]\n")
                    verbose && print_with_color(:white, io, "\n", block.code, "\n\n")
                end
            end
        end
    end
end

doctest(io::IO, m::Module, verbose) =
    isdefined(m, METADATA) ? doctest(io, getfield(m, METADATA), verbose) :
    println(io, "No docs found in module $(m).")

@doc """
Test all code blocks in the docstrings in a module `m`.

Run `doctest(Docile)` to see some sample output produced by this
function.
""" {
    :tags => ["testing", "code blocks"],
    :parameters => [
        (:m, "the module to test"),
        (:verbose, "optional switch to view detailed output of each test")
        ]
    } ->
function doctest(m::Module; verbose = false)
    doctest(STDOUT, m, verbose)
end
