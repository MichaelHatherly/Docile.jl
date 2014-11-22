module MethodDocs

using Docile

@doc meta("documentation", sig = (Float64,)) ->
f(x::Float64) = x

@doc meta("documentation", sig = (Int,)) ->
f(x::Int) = x

@doc meta("documentation", sig = (Vector, Int)) ->
f(x::Vector, y::Int) = x

@doc meta("documentation", sig = (Int, Float64)) ->
f(x::Int, y::Float64) = x

@doc meta("documentation", sig = (Char, Complex, Float64)) ->
f(x::Char, y::Complex, z::Float64) = x

@doc meta("documentation", sig = (Vector, Char, Real)) ->
f(x::Vector, y::Char, z::Real) = x

@doc meta("documentation", sig = (Float64, Matrix{Int})) ->
f(x::Float64, y::Matrix{Int}) = x

@doc "Generic function docstring." -> f

end

@test length(entries(documentation(MethodDocs))) == 8

# Have the methods been added correctly to __METADATA__
# with the right :sig associated with each?
for mt in MethodDocs.f.env
    ent = entries(documentation(MethodDocs))[mt]
    @test mt.sig === metadata(ent)[:sig]
    @test data(docs(ent)) == "documentation"
end

@test modulename(documentation(MethodDocs)) === MethodDocs
