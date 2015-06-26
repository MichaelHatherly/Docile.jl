# Short

"f_0/0"
f_0() = ()

"f_1/1"
f_1(x) = ()

"""f_2/1"""
f_2(x) = ()

# Long

"f_3/1"
function f_3(x)
    ()
end

"""f_4/1"""
function f_4(x)
    ()
end

# Complex type signatures.

"f_5"
f_5{T <: Integer}(a::T, b::Vector{T}, c::Complex{T}) = ()

"f_6"
f_6(::Type{ASCIIString}, a::Array{Int8,1}) = ()

"f_7"
f_7(n::Union(Int64,Int64)) = ()

"f_8"
f_8{T<:Integer}(n::T, k::T) = ()

"f_9"
f_9{T<:Real}(::Complex{T}, x::Real) = ()

"f_10"
f_10{N}(dest::Array, src::Array, I::NTuple{N,Union(Int,AbstractVector)}...) = ()

"f_11"
f_11(V, indexes::NTuple, dims::Dims, linindex::UnitRange{Int}) = ()

"f_12"
f_12{T}(::Type{typejoin()}, ::Type{T}) = ()

"f_13"
f_13{T<:Union(Float32,Float64)}(::Type{T},i::Integer) = ()

"f_14"
f_14{T<:FloatingPoint}(f, a::T,b::T,c::T...;
                       abstol=zero(T),
                       reltol=sqrt(eps(T)),
                       maxevals=10^7,
                       order=7,
                       norm=vecnorm
                       ) = ()

"f_15"
f_15(b, z, m = length(b) + 1) = ()

"f_16"
f_16{T<:Integer}(::Type{T}, x::FloatingPoint; tol::Real = eps(x)) = ()

"f_17"
f_17(io::IO, itr::AbstractArray, op, delim, cl, delim_one, compact = false) = ()

"f_18"
f_18(io::IO, items, sep, indent::Int, prec::Int = 0, enclose_operators::Bool = false) = ()

"f_19"
f_19{T,N,P,IV}(V::SubArray{T,N,P,IV}, m::Real) = ()

"f_20"
f_20{T,N,P,IV}(V::SubArray{T,N,P,IV}, I::AbstractArray{Bool,N}) = ()

"f_21"
f_21{T,N,P,IV}(V::SubArray{T,N,P,IV}, v, I::Union(Real,AbstractVector)...) = ()

"f_22"
f_22(::Type{Ptr{Int8}}, s::ByteString) = ()

"f_23"
f_23(T, matvecA::Function, matvecB::Function, solveSI::Function, n::Integer,
     sym::Bool, cmplx::Bool, bmat::ASCIIString,
     nev::Integer, ncv::Integer, which::ASCIIString,
     tol::Real, maxiter::Integer, mode::Integer, v0::Vector) = ()

"f_24"
f_24{T}(::Matrix{T}, A::Bidiagonal{T}) = ()

"f_25"
f_25(f::ANY, t::Array, i, lim::Integer, matching::Array{Any,1}) = ()

"f_26"
f_26(f::Function, types::tup(Vararg{Type})) = ()

"f_27"
f_27(f::Base.Callable, ::tup(), ts::Tuple...) = ()

"f_28"
f_28(x::tup(Any, Vararg{Any})) = ()

"f_29"
f_29(f::Base.Callable, t::tup(Any,Any), s::tup(Any,Any)) = ()

"f_30"
f_30{T, S}(::Type{Matrix{T}}, ::Type{Vector{S}}) = ()

"f_31"
f_31{T <: Integer, S <: Real, N}(::Type{Array{T, N}}, ::S, other = nothing) = ()

"f_32"
f_32{T, S}(::Type{Matrix{T}}, ::Type{Vector{S}}) = ()

"f_33"
f_33{T <: Integer, S <: Real}(::Type{Matrix{T}}, ::Type{Vector{S}}) = ()

# Generic functions.

"g_f_1"
f_1

"""g_f_2"""
f_2

# Generic pre-docs.

"f_34";
:f_34

f_34() = ()

"""f_35""";
:f_35

f_35() = ()

# Grouped docstrings.

"f_36";
(:f_36, Vararg)

f_36() = ()
f_36(x) = ()
f_36(x, y) = ()
f_36(x, y, z) = ()

# [] group syntax.

"f_37";
[:f_37, :f_37!]

f_37() = ()
f_37!() = ()

"f_38/f_39";
[(:f_38, Any), (:f_39, Any)]

f_38(x) = ()
f_39(x) = ()

f_40(x) = ()
f_40!(x) = ()

"f_40";
[f_40, f_40!]

f_41()  = ()
f_41(x) = ()
f_42()  = ()
f_42(x) = ()

"f_41/f_42";
[(f_41,),
 (f_41, Any),
 (f_42,),
 (f_42, Any)]

# Multiline Signatures.

"f_43"
function f_43(
        a,
        b,
        c
        )
    ()
end
