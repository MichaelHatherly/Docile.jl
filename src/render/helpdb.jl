
"""
Save `docs` in the `package`-specific cache directory in a format
compatible with the standard julia helpdb file.
"""
function helpdb(package::String, docs::Vector{Doc})
    open(joinpath(makecache(package), "helpdb.jl"), "w") do f
        info("Writing helpdb cache for $(package).")
        print(f, Any[helpdb(doc) for doc in docs])
    end
end

function helpdb(doc::Doc)
    (join(modulepath(doc), "."), name(doc), """
    $(sig(doc))

    $(indent(docs(doc)))

    """)
end
