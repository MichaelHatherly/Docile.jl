module QueriesTests

export Queries

module Queries

using Docile
@docstrings

export GLOBAL, f, TestType, mac

@doc { :name => "global" } ->
const GLOBAL = 1

@doc { :name => "x::Int" } ->
f(x::Int) = x

@doc { :name => "x::String" } ->
f(x::String) = x

@doc { :name => "generic function" } -> f

@doc { :name => "TestType" } ->
type TestType
end

@doc { :name => "Macro" } ->
macro mac()
end

end

using Base.Test
using .Queries
using Docile
@docstrings

function tester(result, name)
    @test length(result) == 1
    @test result.entries[1][2].meta[:name] == name
end

# macro versions
tester(@query(global GLOBAL),         "global")
tester(@query(global Queries.GLOBAL), "global")

tester(@query(f(1)),         "x::Int")
tester(@query(Queries.f(1)), "x::Int")

tester(@query(f("1")),         "x::String")
tester(@query(Queries.f("1")), "x::String")

tester(@query(TestType),         "TestType")
tester(@query(Queries.TestType), "TestType")

tester(@query(@mac),         "Macro")
tester(@query(Queries.@mac), "Macro")

# function version
@test length(query(f)) == 3
@test length(query(Queries.f)) == 3

tester(query(TestType), "TestType")
tester(query(Queries.TestType), "TestType")

# should raise an error with this kind of query
@test_throws ErrorException Docile.parsequery(1)

end
