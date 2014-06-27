
"""
Save `docs` as a markdown-formatted `docs.md` file in `package` cache.
"""
function plain(package::String, docs::Vector{Doc})
    open(joinpath(makecache(package), "docs.md"), "w") do f
        println(f, """
        # $(package) Documentation
        """)
        for doc in docs
            writemime(f, "text/plain", doc)
        end
    end
end

function writemime(io::IO, ::MIME"text/plain", doc::Doc)
    println(io, """
    **`$(fullsig(doc))`**

    $(docs(doc))""")
end
