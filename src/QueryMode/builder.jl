
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
