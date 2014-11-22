module QualifiedMethods

using Docile

type Foo
    a::Vector
end

@doc "getindex method for Foo" ->
Base.getindex(f::Foo, i::Integer) = f.a[i]

@doc meta("setindex! method for Foo with metadata.",
          status = :Stable) ->
Base.Meta.show_sexpr(::Foo) = ()

end

@test length(entries(documentation(QualifiedMethods))) == 2
