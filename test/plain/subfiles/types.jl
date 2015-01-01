## Abstract

"T_A_1"
abstract T_A_1

"""T_A_2"""
abstract T_A_2

## Mutable

"T_M_1"
type T_M_1
end

"""T_M_2"""
type T_M_2
end

## Immutable

"T_I_1"
immutable T_I_1
end

"""T_I_2"""
immutable T_I_2
end

## Inner constructors

"""T_IC_1"""
type T_IC_1

    "T_IC_1/0"
    T_IC_1() = new()

    """T_IC_1/1"""
    T_IC_1(x) = new()

end

"T_IC_2"
immutable T_IC_2{T}

    """T_IC_2/0"""
    T_IC_2() = new()

    "T_IC_2/1-2"
    T_IC_2(a, b = 1) = new()

end

"T_IC_3"
type T_IC_3{T <: Real}

    "T_IC_3/1"
    T_IC_3(::Integer) = new()

    "T_IC_3/2"
    T_IC_3(::T, ::T) = new()

    "T_IC_3/3"
    T_IC_3(::Type{Matrix{T}}, ::Array{T, 1}, a::Int...) = new()

end
