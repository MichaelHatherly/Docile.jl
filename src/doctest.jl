@doc "Stores detailed results from a `doctest` run." ->
type Summary
    modname::Module
    total::Int
    pass::Int
    fail::Int
    skip::Int

    Summary(modname) = new(modname, 0, 0, 0, 0)
end

total!(s::Summary) = s.total += 1
pass!(s::Summary) = s.pass += 1
fail!(s::Summary) = s.fail += 1
skip!(s::Summary) = s.skip += 1

function writemime(io::IO, mime::MIME"text/plain", s::Summary)
    println(io, "[module summary]\n")
    println(io, """
     *   module: $(s.modname)
     * exported: $(length(names(s.modname)))
     *  entries: $(length(getfield(s.modname, METADATA).entries))
    """)

    println(io, "[doctest summary]\n")
    @printf(io, " * pass: %5d / %d\n", s.pass, s.total)
    @printf(io, " * fail: %5d / %d\n", s.fail, s.total)
    @printf(io, " * skip: %5d / %d\n", s.skip, s.total)
end

# For running tests in a "clean" environment.
module Sandbox end

@doc """
Run code blocks in the docstrings of the specified module `modname`.

Code blocks may be skipped by adding an extra newline at the end of the
block.

**Examples:**

```julia
doctest(Docile)
doctest(Docile; verbose = true)

```
""" {
    :parameters => {
        (:modname, "The module to try and test."),
        (:verbose, "Optional boolean flag to show details of each test. Defaults to false.")
        },
    :returns => (Summary,)
    } ->
function doctest(modname::Module; verbose = false)
    isdefined(modname, METADATA) || error("doctest: $(modname) is not documented.")

    # Import the module being tested into the sandbox.
    eval(Sandbox, Expr(:toplevel, Expr(:using, symbol("$(modname)"))))

    summ = Summary(modname)
    println("running doctest on $(modname)...")

    for (obj, entry) in getfield(modname, METADATA).entries
        verbose && println(" • [ENTRY] $(obj)")
        for block in entry.docs.content
            if isa(block, Markdown.BlockCode) # block.language == :julia
                total!(summ)
                verbose && print_with_color(:purple, "  ∘ [EVAL]\n")
                success = true
                try
                    if endswith(block.code, "\n") # skip code block with trailing newline
                        skip!(summ)
                        verbose && print_with_color(:blue, "  ~ [SKIPPED]\n")
                        continue
                    end
                    eval(Sandbox, parse("let\n$(block.code)\nend"))
                catch err
                    success = false
                    fail!(summ)
                    if verbose
                        print_with_color(:red, "  - [FAILURE]\n")
                        println("\n", block.code, "\n")
                        print_with_color(:red, string(err), "\n\n")
                    end
                end
                if success
                    pass!(summ)
                    if verbose
                        print_with_color(:green, "  + [SUCCESS]\n")
                        print_with_color(:white, "\n", block.code, "\n\n")
                    end
                end
            end
        end
    end
    summ
end
