
abstract Term

immutable Query
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
