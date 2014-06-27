# TODO: tidy, extend

function writemime(io::IO, ::MIME"text/html", doc::Doc)
    print(io, """
    <div class="docile entry header $(category(doc))">$(escape(fullsig(doc)))</div>

    <div class="docile entry description">
    $(sprint(i -> Markdown.html_inline(i, Markdown.parse(docs(doc)))))
    </div>
    """)
end

"""
Save `docs` as a self-contained html page in `package` cache.
"""
function html(package::String, docs::Vector{Doc})
    open(joinpath(makecache(package), "docs.html"), "w") do f
        print(f, """
        <!DOCTYPE html>
        <html lang="en">
            <head>
                <title>$(package) Documentation</title>
                <style>
                body {
                    max-width: 650px;
                    margin: 0 auto;
                    padding: 10px;
                }
                .docile.entry.header {
                    font-family: monospace;
                    font-weight: bold;
                    font-size: 1.3em;
                }
                .docile.entry.description {
                    padding: 10px;
                }
                </style>
            </head>
            <body>
                <h1>$(package) Documentation</h1>
        """)
        for doc in docs
            writemime(f, "text/html", doc)
        end
        print(f, """
          </body>
        </html>
        """)
    end
end
