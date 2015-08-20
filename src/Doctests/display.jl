
Base.writemime(io :: IO, mime :: MIME"text/plain", result :: Result) =
    print(io, "Result($(result.modname), $(result.status), ...)")

function details(io :: IO, rs :: Results, all)
    print_with_color(:white, io, "Doctest Details:\n\n")
    p, f = passed(rs), failed(rs)
    print_with_color(:red, io, ">>> $(length(f)) failed.\n")
    for each in f
        print(io, template(each))
    end
    if all
        print_with_color(:green, io, ">>> $(length(p)) passed.\n")
        for each in p
            print(io, template(each))
        end
    end
end

"""
    details(results; all = false)

Display details of a doctest. Information provided includes:

- status of the test (either ``Passed`` or ``Failed``)
- module and object names
- value returned after evaluating the code block
- contents of the code block

By default only the failed code blocks will be displayed when calling ``details``. To see
all the results pass the keyword argument ``all = true``.
"""
details(rs :: Results; all = false) = details(STDOUT, rs, all)

template(r) =
"""

$(color(:magenta, "Module:")) $(r.modname)
$(color(:magenta, "Object:")) $(r.object)

$(color(:magenta, "Result:"))

$(r.result)

$(color(:magenta, "Source:"))

$(color(:blue, r.source.code))

"""

color(c, text) = sprint(io -> print_with_color(c, io, text))

function Base.writemime(io :: IO, mime :: MIME"text/plain", rs :: Results)
    text =
    """
    Results(
     total: $(length(rs.results)),
    passed: $(length(filter(r -> r.status == Passed, rs.results))),
    failed: $(length(filter(r -> r.status == Failed, rs.results))),
    )
    """
    print(io, text)
end
