module Web

import Docile
import ..QueryMode: results, exec, @query_str

using Mux, Hiccup
import URIParser, Hiccup.div

function handle(req)
    text = URIParser.unescape(req[:params][:query])
    out  = results(eval(Main, :(Docile.QueryMode.exec(Docile.QueryMode.@query_str($text)))))
    html(head(style(Mux.mux_css)), body(div(out)))
end

function server()
    @app app = (
        Mux.defaults,
        page("/:query", handle),
        Mux.notfound(),
    )
    serve(app)
end

end
