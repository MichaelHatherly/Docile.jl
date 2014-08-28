# Checks for methods being read in correctly.
module MethodDocsTests

using Base.Test

using Docile
@docstrings

@doc """""" { :sig => (String,) } ->
f(x::String) = x

@doc """""" { :sig => (Int,) } ->
f(x::Int) = x

@doc """""" { :sig => (Vector, Int) } ->
f(x::Vector, y::Int) = x

@doc """""" { :sig => (Int, String) } ->
f(x::Int, y::String) = x

@doc """""" { :sig => (Char, Complex, String) } ->
f(x::Char, y::Complex, z::String) = x

@doc """""" { :sig => (Vector, Char, Real) } ->
f(x::Vector, y::Char, z::Real) = x

@doc """""" { :sig => (String, Matrix{Int}) } ->
f(x::String, y::Matrix{Int}) = x

@doc """Generic function docstring.""" -> f

@test isdefined(:__METADATA__)
@test length(__METADATA__.entries) == 8

# Have the methods been added correctly to __METADATA__
# with the right :sig associated with each?
for mt in f.env
    obj, ent = query(mt)[1]

    @test mt === obj
    @test mt.sig === ent.meta[:sig]
end

# querying a function should give back function and all methods
results = query(f)

@test length(results) == 8

# passing ; all = false should only give the function itself
results = query(f; all = false)

@test length(results) == 1
@test isa(results[1][1], Function)
@test isa(results[1][2], Docile.Entry{:function})
@test length(results[1][2].meta) == 1

end
