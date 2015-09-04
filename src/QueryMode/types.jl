
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
end

immutable Metadata <: DataTerm
    data :: Dict{Symbol, Any}
    Metadata(args :: Vector) = new(Dict{Symbol, Any}(args))
end

immutable MatchAnyThing end


abstract TypeTerm <: Term

immutable ArgumentTypes <: TypeTerm
    tuple :: Tuple
end

immutable ReturnTypes <: TypeTerm
    tuple

    ReturnTypes(x) = new(x)
    ReturnTypes(t :: Tuple) = new(Tuple{t...})
end


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
