module MethodDocs

using Docile
@docstrings

@doc "documentation" { :sig => (String,) } ->
f(x::String) = x

@doc "documentation" { :sig => (Int,) } ->
f(x::Int) = x

@doc "documentation" { :sig => (Vector, Int) } ->
f(x::Vector, y::Int) = x

@doc "documentation" { :sig => (Int, String) } ->
f(x::Int, y::String) = x

@doc "documentation" { :sig => (Char, Complex, String) } ->
f(x::Char, y::Complex, z::String) = x

@doc "documentation" { :sig => (Vector, Char, Real) } ->
f(x::Vector, y::Char, z::Real) = x

@doc "documentation" { :sig => (String, Matrix{Int}) } ->
f(x::String, y::Matrix{Int}) = x

@doc "Generic function docstring." -> f

end

@test length(entries(documentation(MethodDocs))) == 8

# Have the methods been added correctly to __METADATA__
# with the right :sig associated with each?
for mt in MethodDocs.f.env
    ent = entries(documentation(MethodDocs))[mt]
    @test mt.sig === metadata(ent)[:sig]
    @test docs(ent) == "documentation"
end

@test modulename(documentation(MethodDocs)) === MethodDocs
