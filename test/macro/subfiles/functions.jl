# Short

Docile.@doc "f_1" ->
f_1(x) = x

Docile.@doc """f_2""" ->
f_2(x) = x

# Full

Docile.@doc "f_3" ->
function f_3(x)
end

Docile.@doc """f_4""" ->
function f_4(x)
end

# Complex type signatures.

Docile.@doc "f_5" ->
f_5{T <: Integer}(a::T, b::Vector{T}, c::Complex{T}) = ()

Docile.@doc "f_6" ->
f_6(::Type{ASCIIString}, a::Array{UInt8,1}) = ()

Docile.@doc "f_7" ->
f_7(n::Union(Int64,UInt64)) = ()

Docile.@doc "f_8" ->
f_8{T<:Integer}(n::T, k::T) = ()

Docile.@doc "f_9" ->
f_9{T<:Real}(::Complex{T}, x::Real) = ()

Docile.@doc "f_10" ->
f_10{N}(dest::Array, src::Array, I::NTuple{N,Union(Int,AbstractVector)}...) = ()

Docile.@doc "f_11" ->
f_11(V, indexes::NTuple, dims::Dims, linindex::UnitRange{Int}) = ()

Docile.@doc "f_12" ->
f_12{T}(::Type{typejoin()}, ::Type{T}) = ()

Docile.@doc "f_13" ->
f_13{T<:Union(Float32,Float64)}(::Type{T},i::Integer) = ()

Docile.@doc "f_14" ->
f_14{T<:FloatingPoint}(f, a::T,b::T,c::T...;
                       abstol=zero(T),
                       reltol=sqrt(eps(T)),
                       maxevals=10^7,
                       order=7,
                       norm=vecnorm
                       ) = ()

Docile.@doc "f_15" ->
f_15(b, z, m = length(b) + 1) = ()

Docile.@doc "f_16" ->
f_16{T<:Integer}(::Type{T}, x::FloatingPoint; tol::Real = eps(x)) = ()

Docile.@doc "f_17" ->
f_17(io::IO, itr::AbstractArray, op, delim, cl, delim_one, compact = false) = ()

Docile.@doc "f_18" ->
f_18(io::IO, items, sep, indent::Int, prec::Int = 0, enclose_operators::Bool = false) = ()

Docile.@doc "f_19" ->
f_19{T,N,P,IV}(V::SubArray{T,N,P,IV}, m::Real) = ()

Docile.@doc "f_20" ->
f_20{T,N,P,IV}(V::SubArray{T,N,P,IV}, I::AbstractArray{Bool,N}) = ()

Docile.@doc "f_21" ->
f_21{T,N,P,IV}(V::SubArray{T,N,P,IV}, v, I::Union(Real,AbstractVector)...) = ()

Docile.@doc "f_22" ->
f_22(::Type{Ptr{UInt8}}, s::ByteString) = ()

Docile.@doc "f_23" ->
f_23(T, matvecA::Function, matvecB::Function, solveSI::Function, n::Integer,
     sym::Bool, cmplx::Bool, bmat::ASCIIString,
     nev::Integer, ncv::Integer, which::ASCIIString,
     tol::Real, maxiter::Integer, mode::Integer, v0::Vector) = ()

Docile.@doc "f_24" ->
f_24{T}(::Matrix{T}, A::Bidiagonal{T}) = ()

Docile.@doc "f_25" ->
f_25(f::ANY, t::Array, i, lim::Integer, matching::Array{Any,1}) = ()

Docile.@doc "f_26" ->
f_26(f::Function, types::Docile.tup(Vararg{Type})) = ()

Docile.@doc "f_27" ->
f_27(f::Base.Callable, ::Docile.tup(), ts::Tuple...) = ()

Docile.@doc "f_28" ->
f_28(x::Docile.tup(Any, Vararg{Any})) = ()

Docile.@doc "f_29" ->
f_29(f::Base.Callable, t::Docile.tup(Any,Any), s::Docile.tup(Any,Any)) = ()

# Generic functions.

Docile.@doc "g_f_1" ->
f_1

Docile.@doc """g_f_2""" ->
f_2

# Star syntax

Docile.@doc+ "g_f_30" ->
f_30() = ()

Docile.@doc "f_30" ->
f_30(x) = ()

Docile.@doc+ meta("g_f_31", returns = (Bool,)) ->
f_31() = true

Docile.@doc meta("f_31", returns = (Bool,)) ->
f_31(x) = true

# Interpolated docstrings.

Docile.@doc+ meta(md"x + y = $(1 + 1)", result = "x + y = \$(1 + 1)") ->
f_32() = ()

Docile.@doc+ meta(md"x + y = $(1 + 1)"i, result = "x + y = 2") ->
f_33(x) = ()

Docile.@doc+ meta(md"""$(1 + (sin(3) + 1))""", result = "\$(1 + (sin(3) + 1))") ->
f_34() = ()

Docile.@doc+ meta(md"""$(1 + (sin(3) + 1))"""i, result = "2.1411200080598674") ->
f_35(x) = ()

# doc_str, doc_mstr macros.

Docile.@doc Docile.@doc_str("f_36") ->
f_36() = ()

Docile.@doc Docile.@doc_str("""f_37""") ->
f_37() = ()

# Qualified methods.

type Foo end

Docile.@doc "Base.getindex" ->
Base.getindex(f::Foo, i::Integer) = f.a[i]

Docile.@doc meta("Base.Meta.show_sexpr") ->
Base.Meta.show_sexpr(::Foo) = ()
