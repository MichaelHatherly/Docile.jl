"""
$(moduleheader())

$(exports())
"""
module Queries

using ..Utilities

using Base.Meta


__init__() = initmode()


immutable Head{s} end

head(ex :: Expr) = Head{ex.head}()

macro H_str(text)
    Expr(:call, :Union, [Head{symbol(part)} for part in split(text, ", ")]...)
end

function nullmatch(reg::Regex, text::AbstractString)
    out = match(reg, text)
    out == nothing && return Nullable{RegexMatch}()
    Nullable{RegexMatch}(out)
end

const INTEGER_REGEX = r"\s([-+]?\d+)$"

function splitquery{S <: AbstractString}(text::S)
    m = nullmatch(INTEGER_REGEX, text)
    isnull(m) && return (text, 0)
    convert(S, split(text, INTEGER_REGEX)[1]), parse(Int, m.value.match)
end


# Query types.

abstract Term

immutable Query
    text  :: UTF8String
    term  :: Term
    index :: Int
end


abstract DataTerm <: Term

immutable Text <: DataTerm
    text :: UTF8String
end

immutable RegexTerm <: DataTerm
    regex :: Regex
end

immutable Object <: DataTerm
    mod    :: Module
    symbol :: Symbol
    object :: Any

    Object(mod, symbol, object)           = new(mod, symbol, object)
    Object(mod, symbol, object :: Module) = new(object, symbol, object)
end

immutable Metadata <: DataTerm
    data :: Dict{Symbol, Any}
    Metadata(args :: Vector) = new(Dict{Symbol, Any}(args))
end

immutable MatchAnyThing end


abstract TypeTerm <: Term

immutable ArgumentTypes <: TypeTerm
    tuple
    ArgumentTypes(x) = new(astuple(x))
end

immutable ReturnTypes <: TypeTerm
    tuple
    ReturnTypes(x) = new(astuple(x))
end

astuple(x)          = x
astuple(x :: Tuple) = Tuple{x...}

abstract LogicTerm <: Term

immutable And <: LogicTerm
    left  :: Term
    right :: Term
end

immutable Or <: LogicTerm
    left  :: Term
    right :: Term
end

immutable Not <: LogicTerm
    term :: Term
end


# Building query trees.

macro query_str(text) buildquery(text) end

function buildquery(text :: Str)
    query, index = splitquery(text)
    index < 0 && error("Index must be positive.")
    buildquery(strip(query), parse(query), index)
end

buildquery(raw, text :: Str, index :: Int) =
    :(Query($(raw), Text($(esc(text))), $(index)))

buildquery(raw, s :: Symbol, index :: Int) =
    :(Query($(raw), Object(which($(quot(s))), $(quot(s)), $(esc(s))), $(index)))

buildquery(raw, ex :: Expr, index :: Int) =
    :(Query($(raw), $(build(ex)), $(index)))

buildquery(others...) = error("Invalid query syntax.")

build(text :: Str) = :(Text($(esc(text))))
build(s :: Symbol) = :(Object(which($(quot(s))), $(quot(s)), $(esc(s))))
build(ex :: Expr)  = build(head(ex), ex)

function build(:: H"call", ex :: Expr)
    func, args = ex.args[1], ex.args[2:end]
    # Logical terms.
    func == :& ? :(And($(build(args[1])), $(build(args[2])))) :
    func == :| ? :( Or($(build(args[1])), $(build(args[2])))) :
    func == :! ? :(Not($(build(args[1])))) :
    # Standard method calls.
    :(And($(build(func)), $(build(Expr(:tuple, args...)))))
end

build(:: H".", ex :: Expr) = :(Object($(esc(ex.args[1])), $(ex.args[end]), $(esc(ex))))

build(:: H"tuple", ex :: Expr) = :(ArgumentTypes($(esc(ex))))

build(:: H"macrocall", ex :: Expr) = (ex.args[1] ≡ symbol("@r_str") && ex.args[2] ≠ "") ?
    :(RegexTerm($(esc(ex)))) : build(ex.args[1])

function build(:: H"::", ex :: Expr)
    out = :(ReturnTypes($(esc(ex.args[end]))))
    length(ex.args) > 1 ? :(And($(build(ex.args[1])), $(out))) : out
end

build(:: H"vect", ex :: Expr) = :(Metadata($(Expr(:ref, :Any, map(buildvect, ex.args)...))))

build(others...) = error("Invalid query syntax.")

buildvect(ex :: Expr)  = Expr(:tuple, extractpair(ex)...)
buildvect(s :: Symbol) = Expr(:tuple, quot(s), :(MatchAnyThing()))

buildvect(others...) = error("Invalid metadata syntax.")

function extractpair(ex :: Expr)
    isexpr(ex, :(=), 2) || error("Invalid metadata syntax.")
    k, v = ex.args
    isa(k, Symbol) ? (quot(k), esc(v)) : error("Invalid metadata key.")
end


# Running and displaying Queries.

import Base.Docs: FuncDoc, TypeDoc, Binding
import Base.Markdown: MD, List, Paragraph, Bold, Code
import Base.REPL

immutable Results
    query :: Query
    data  :: Vector
end

function results(r :: Results)
    length(r.data) == 1                ? r.data[1][4] :
    0 < r.query.index ≤ length(r.data) ? r.data[r.query.index][4] :
    isempty(r.data)                    ? MD(Paragraph("No results found for query.")) :
    MD(
        Paragraph([
            Bold("Search Results."),
            " (To view an entry listed below append it's number to previous query.)"
        ]),
        List([Code(string(each[3])) for each in r.data], true),
    )
end

Base.writemime(io :: IO, mime :: MIME"text/plain", r :: Results) =
    writemime(io, mime, results(r))

Base.display(d :: REPL.REPLDisplay, r :: Results) =
    Markdown.term(REPL.outstream(d.repl), results(r))


metadata(m) = isdefined(m, :__META__) ? m.__META__ : ObjectIdDict()

"""
    exec(query)

Execute a `Query` object and return the `Result` containing docstrings found.
"""
function exec end

# Cache the previous results for faster interaction when indexing queries.
let __cache__ = Ref{Results}()
    function exec(query :: Query)
        if cached(__cache__, query)
            __cache__.x = Results(query, __cache__.x.data)
        else
            rs = Results(query, [])
            for m in Base.Docs.modules, (k, v) in metadata(m)
                isa(k, ObjectIdDict) && continue
                getdoc!(rs, m, k, v)
            end
            sort!(rs.data, by = first, rev = true) # Sort results by score.
            __cache__.x = rs
        end
        __cache__.x
    end
end

cached(cache, query) =
    isdefined(Main, :ans) &&
    isdefined(cache, :x)  &&
    Main.ans == cache.x   &&
    cache.x.query.text == query.text

function getdoc!(rs :: Results, m, k, v :: Union{FuncDoc, TypeDoc})
    getdoc!(rs, m, k, v.main)
    for sig in v.order
        getdoc!(rs, score(rs, m, (k, sig), v.meta[sig]), m, makesig(k, v, sig), v.meta[sig])
    end
end

getdoc!(rs :: Results, m, k, v) = getdoc!(rs, score(rs, m, k, v), m, k, v)

getdoc!(rs :: Results, m, k, :: Nothing) = nothing
getdoc!(others...)                       = nothing

getdoc!(rs, s, m, k, v) = (s > 0 && push!(rs.data, (s, m, k, v)); nothing)

function makesig(k, v, sig :: Union)
    isempty(sig.types) && return string(k)
    _, index = findmax([length(x.parameters) for x in sig.types])
    singlesig(k, sig.types[index])
end
makesig(k, v, sig :: DataType) = singlesig(k, sig)

singlesig(k, sig) = string(k, "(", join(sig.parameters, ", "), ")")

# Query scoring.

score(rs :: Results, args...) = score(rs.query.term, args...)

# Text and Regex.

score(x :: Text, m, k, v)      = mdscore(x, v)
score(x :: RegexTerm, m, k, v) = mdscore(x, v)

mdscore(x, y :: Markdown.MD)         = mdscore(x, y.content)
mdscore(x, y :: Markdown.BlockQuote) = mdscore(x, y.content)
mdscore(x, y :: Markdown.Bold)       = mdscore(x, y.text)
mdscore(x, y :: Markdown.Code)       = mdscore(x, y.code)
mdscore(x, y :: Markdown.Header)     = mdscore(x, y.text)
mdscore(x, y :: Markdown.Italic)     = mdscore(x, y.text)
mdscore(x, y :: Markdown.LaTeX)      = mdscore(x, y.formula)
mdscore(x, y :: Markdown.Link)       = mdscore(x, y.text)
mdscore(x, y :: Markdown.Paragraph)  = mdscore(x, y.content)
mdscore(x, y :: Markdown.Table)      = mdscore(x, y.rows)

mdscore(x, y :: Vector) = (s = 0.0; for c in y; s += mdscore(x, c); end; s)

mdscore(x :: Text,      y :: AbstractString) = spliter(x.text, y)
mdscore(x :: RegexTerm, y :: AbstractString) = spliter(x.regex, y)

spliter(x, y) = (length(split(y, x))  - 1) / length(y)

mdscore(x, y) = 0.0

# Object.

score(x :: Object, m, k, v) = score(x, m, k) + (x.object == m ? 0.1 : 0.0)

score(x :: Object, m, k)            = x.object == k        ? 1.0 : 0.0
score(x :: Object, m, k :: Tuple)   = x.object == k[1]     ? 0.5 : 0.0
score(x :: Object, m, k :: Binding) = x.symbol == k.var    ? 0.5 : 0.0
score(x :: Object, m, k :: Module)  = matchmodule(x, m, k) ? 1.0 : 0.0

matchmodule(x, m, k) = x.mod == k && x.symbol == module_name(m)

# Metadata.

score(x :: Metadata, m, k, v :: Markdown.MD) = 0.0

# ArgumentTypes.

score(x :: ArgumentTypes, m, k :: Tuple, v) = x.tuple <: k[2] ? 1.0 : 0.0

# ReturnTypes.

score(x :: ReturnTypes, m, k :: Tuple{Function, Type}, v) = signatures(x, k...)

function signatures(x, f, t)
    out = 0.0
    isgeneric(f) && for m in methods(f, t)
        out += x.tuple <: returned(m) ? 1.0 : 0.0
    end
    out
end

function signatures(x, f, u :: Union)
    out = 0.0
    for sig in u.types
        out += signatures(x, f, sig)
    end
    out
end

returned(obj) = Core.Inference.typeinf(obj.func.code, obj.sig, Core.svec())[2]

# Logical Terms.
function score(x :: And, m, k, v)
    (left = score(x.left, m, k, v)) > 0 || return 0.0 # Shortcircuit.
    left * score(x.right, m, k, v)
end
score(x :: Or,  m, k, v) = score(x.left, m, k, v) + score(x.right, m, k, v)
score(x :: Not, m, k, v) = score(x.term, m, k, v) > 0.0 ? 0.0 : 1.0

# Skip everything else.
score(others...) = 0.0


# Debug printing.

indent(n) = " "^4n

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Query, level = 0)
    println(io, "Query(")
    writemime(io, mime, x.term, 1)
    print(io, ")[$(x.index)]")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Text, level)
    println(io, indent(level), "Text(\"$(x.text)\")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: RegexTerm, level)
    println(indent(level), "RegexTerm($(x.regex))")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Object, level)
    println(indent(level), "Object(")
    println(indent(level + 1), "module: $(x.mod)")
    println(indent(level + 1), "symbol: $(x.symbol)")
    println(indent(level + 1), "object: $(x.object)")
    println(indent(level), ")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Metadata, level)
    println(indent(level), "Metadata(")
    if length(x.data) > 0
        width = maximum([length(string(k)) for k in keys(x.data)])
        for (k, v) in x.data
            print(io, indent(level + 1), rpad(string(k), width), " = ")
            println(io, isa(v, MatchAnyThing) ? "?" : repr(v))
        end
    end
    println(indent(level), ")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: TypeTerm, level)
    println(indent(level), "$(typeof(x).name.name)(")
    println(indent(level + 1), x.tuple)
    println(indent(level), ")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Union{And, Or}, level)
    println(indent(level), "$(typeof(x).name.name)(")
    writemime(io, mime, x.left, level + 1)
    writemime(io, mime, x.right, level + 1)
    println(io, indent(level), ")")
end

function Base.writemime(io :: IO, mime :: MIME"text/plain", x :: Not, level)
    println(indent(level), "Not(")
    writemime(io, mime, x.term, level + 1)
    println(io, indent(level), ")")
end


# REPL mode.

import Base: LineEdit, REPL

function initmode(;
    text  = "query> ",
    color = "\e[35;5;166m",
    key   = ']',
    )

    # Not always defined, so skip if we can't find the REPL.
    isdefined(Base, :active_repl) || return

    repl       = Base.active_repl
    julia_mode = repl.interface.modes[1]

    query_mode = LineEdit.Prompt(text;
        prompt_prefix    = color,
        prompt_suffix    = Base.text_colors[:white],
        keymap_func_data = repl,
        on_enter         = REPL.return_callback,
        complete         = REPL.REPLCompletionProvider(repl),
    )
    query_mode.on_done = REPL.respond(repl, query_mode) do line
        :(Docile.Queries.exec(Docile.Queries.@query_str($(line))))
    end

    push!(repl.interface.modes, query_mode)

    hp                      = julia_mode.hist
    hp.mode_mapping[:query] = query_mode
    query_mode.hist         = hp

    search_prompt, skeymap = LineEdit.setup_search_keymap(hp)

    mk = REPL.mode_keymap(julia_mode)

    const query_keymap = Dict(
        key => (s, args...) ->
            if isempty(s) || position(LineEdit.buffer(s)) == 0
                buf = copy(LineEdit.buffer(s))
                LineEdit.transition(s, query_mode) do
                    LineEdit.state(s, query_mode).input_buffer = buf
                end
            else
                LineEdit.edit_insert(s, key)
            end
    )

    query_mode.keymap_dict = LineEdit.keymap(Dict[
        skeymap,
        mk,
        LineEdit.history_keymap,
        LineEdit.default_keymap,
        LineEdit.escape_defaults,
    ])
    julia_mode.keymap_dict = LineEdit.keymap_merge(julia_mode.keymap_dict, query_keymap)

    nothing
end

end  # module Queries
