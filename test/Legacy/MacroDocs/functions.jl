# Short

@doc "f_1" ->
f_1(x) = x

@doc """f_2""" ->
f_2(x) = x

# Full

@doc "f_3" ->
function f_3(x)
end

@doc """f_4""" ->
function f_4(x)
end

# Complex type signatures.

@doc "f_5" ->
f_5{T <: Integer}(a::T, b::Vector{T}, c::Complex{T}) = ()

@doc "f_6" ->
f_6(::Type{ASCIIString}, a::Array{Int8,1}) = ()

@doc "f_7" ->
f_7(n::Union(Int64,Int32)) = ()

@doc "f_8" ->
f_8{T<:Integer}(n::T, k::T) = ()

@doc "f_9" ->
f_9{T<:Real}(::Complex{T}, x::Real) = ()

@doc "f_10" ->
f_10{N}(dest::Array, src::Array, I::NTuple{N,Union(Int,AbstractVector)}...) = ()

@doc "f_11" ->
f_11(V, indexes::NTuple, dims::Dims, linindex::UnitRange{Int}) = ()

@doc "f_12" ->
f_12{T}(::Type{typejoin()}, ::Type{T}) = ()

@doc "f_13" ->
f_13{T<:Union(Float32,Float64)}(::Type{T},i::Integer) = ()

@doc "f_14" ->
f_14{T<:FloatingPoint}(f, a::T,b::T,c::T...;
                       abstol=zero(T),
                       reltol=sqrt(eps(T)),
                       maxevals=10^7,
                       order=7,
                       norm=vecnorm
                       ) = ()

@doc "f_15" ->
f_15(b, z, m = length(b) + 1) = ()

@doc "f_16" ->
f_16{T<:Integer}(::Type{T}, x::FloatingPoint; tol::Real = eps(x)) = ()

@doc "f_17" ->
f_17(io::IO, itr::AbstractArray, op, delim, cl, delim_one, compact = false) = ()

@doc "f_18" ->
f_18(io::IO, items, sep, indent::Int, prec::Int = 0, enclose_operators::Bool = false) = ()

@doc "f_19" ->
f_19{T,N,P,IV}(V::SubArray{T,N,P,IV}, m::Real) = ()

@doc "f_20" ->
f_20{T,N,P,IV}(V::SubArray{T,N,P,IV}, I::AbstractArray{Bool,N}) = ()

@doc "f_21" ->
f_21{T,N,P,IV}(V::SubArray{T,N,P,IV}, v, I::Union(Real,AbstractVector)...) = ()

@doc "f_22" ->
f_22(::Type{Ptr{Int8}}, s::ByteString) = ()

@doc "f_23" ->
f_23(T, matvecA::Function, matvecB::Function, solveSI::Function, n::Integer,
     sym::Bool, cmplx::Bool, bmat::ASCIIString,
     nev::Integer, ncv::Integer, which::ASCIIString,
     tol::Real, maxiter::Integer, mode::Integer, v0::Vector) = ()

@doc "f_24" ->
f_24{T}(::Matrix{T}, A::Bidiagonal{T}) = ()

@doc "f_25" ->
f_25(f::ANY, t::Array, i, lim::Integer, matching::Array{Any,1}) = ()

@doc "f_26" ->
f_26(f::Function, types::tup(Vararg{Type})) = ()

@doc "f_27" ->
f_27(f::Base.Callable, ::tup(), ts::Tuple...) = ()

@doc "f_28" ->
f_28(x::tup(Any, Vararg{Any})) = ()

@doc "f_29" ->
f_29(f::Base.Callable, t::tup(Any,Any), s::tup(Any,Any)) = ()

# Generic functions.

@doc "g_f_1" ->
f_1

@doc """g_f_2""" ->
f_2

# Star syntax

@doc "f_30" ->
f_30() = ()

@doc+ "g_f_30" ->
f_30(x) = ()

@doc meta("f_31", returns = Bool) ->
f_31() = true

@doc+ meta("g_f_31", returns = Int) ->
f_31(x) = true

# doc_str, doc_mstr macros.

@doc doc"f_36" ->
f_36() = ()

@doc doc"""f_37""" ->
f_37() = ()

# Qualified docs.

type FooType end

@doc "f_38" ->
Base.Pkg.add(::FooType) = 1
