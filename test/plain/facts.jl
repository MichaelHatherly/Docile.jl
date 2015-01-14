include("module.jl")

import Docile.Interface: metadata, isexported

### Helper methods.
meta = metadata(PlainDocs)
docs(obj)  = meta.entries[obj].docs.data

macro_lambda(s)    = getfield(PlainDocs, symbol(s))
macro_signature(s) = meta.entries[macro_lambda(symbol(s))].data[:signature]

fmeth(obj) = first(methods(obj))
fmeth(obj, T) = first(methods(obj, T))
###

facts("Plain docstrings.") do

    context("Basics.") do

        @fact length(meta.entries) => 90

        @fact meta.data => @compat Dict{Symbol, Any}(
            :format   => :md,
            :loopdocs => true,
            :manual   => ["../../doc/manual.md"])

        @fact meta.root => joinpath(dirname(@__FILE__), "module.jl")

        @fact length(meta.files) => 5

        @fact meta.modname => PlainDocs

    end

    context("Methods.") do

        for i = 1:33
            fn = string("f_", i)
            @fact docs(fmeth(getfield(PlainDocs, symbol(fn)))) => fn
        end

        context("Qualified names.") do

            @fact docs(fmeth(factorize, (Symbol, Symbol)))  => "Base.factorize"
            @fact docs(fmeth(factorize, (AbstractString,))) => "Base.factorize{T}"
            @fact docs(fmeth(norm, (AbstractString,)))      => "Base.LinAlg.norm"
            @fact docs(fmeth(norm, (AbstractString, Int)))  => "Base.LinAlg.norm{T}"

        end

        context("Grouped methods.") do

            @fact docs(fmeth(PlainDocs.f_36, ()))              => "f_36"
            @fact docs(fmeth(PlainDocs.f_36, (Any,)))          => "f_36"
            @fact docs(fmeth(PlainDocs.f_36, (Any, Any,)))     => "f_36"
            @fact docs(fmeth(PlainDocs.f_36, (Any, Any, Any))) => "f_36"

        end

    end

    context("Functions.") do

        @fact docs(PlainDocs.f_1) => "g_f_1"
        @fact docs(PlainDocs.f_2) => "g_f_2"

        @fact docs(PlainDocs.f_33) => "f_33"
        @fact docs(PlainDocs.f_34) => "f_34"

    end

    context("Macros.") do

        @fact docs(macro_lambda("@m_1")) => "m_1"
        @fact docs(macro_lambda("@m_2")) => "m_2"

        @fact macro_signature("@m_1") => :(m_1(x))
        @fact macro_signature("@m_2") => :(m_2(x))

    end

    context("Types & constructors.") do

        @fact docs(PlainDocs.T_A_1) => "T_A_1"
        @fact docs(PlainDocs.T_A_2) => "T_A_2"

        @fact docs(:T_TA_1) => "T_TA_1"
        @fact docs(:T_TA_2) => "T_TA_2"

        @fact docs(PlainDocs.T_M_1) => "T_M_1"
        @fact docs(PlainDocs.T_M_2) => "T_M_2"

        @fact docs(PlainDocs.T_I_1) => "T_I_1"
        @fact docs(PlainDocs.T_I_2) => "T_I_2"

        @fact docs(PlainDocs.T_IC_1) => "T_IC_1"

        @fact docs(fmeth(PlainDocs.T_IC_1, ()))     => "T_IC_1/0"
        @fact docs(fmeth(PlainDocs.T_IC_1, (Any,))) => "T_IC_1/1"

        @fact docs(PlainDocs.T_IC_2) => "T_IC_2"

        @fact docs(fmeth(PlainDocs.T_IC_2{Any}, ()))         => "T_IC_2/0"
        @fact docs(fmeth(PlainDocs.T_IC_2{Any}, (Any,)))     => "T_IC_2/1-2"
        @fact docs(fmeth(PlainDocs.T_IC_2{Any}, (Any, Any))) => "T_IC_2/1-2"

        @fact docs(PlainDocs.T_IC_3) => "T_IC_3"

        @fact docs(fmeth(PlainDocs.T_IC_3{Real}, (Integer,))) => "T_IC_3/1"
        @fact docs(fmeth(PlainDocs.T_IC_3{Real}, (Real,Real))) => "T_IC_3/2"
        @fact docs(fmeth(PlainDocs.T_IC_3{Real},
                         (Type{Matrix{Real}},
                          Vector{Real},
                          Vararg{Int})
                         )) => "T_IC_3/3"

    end

    context("Global variables.") do

        @fact docs(:G_M_1) => "G_M_1"
        @fact docs(:G_M_2) => "G_M_2"

        @fact docs(:G_C_1) => "G_C_1"
        @fact docs(:G_C_2) => "G_C_2"

    end

    context("Loop generated.") do

        for i = 1:2, T = (Integer, Float64), fn = [:lg_1, :lg_2]
            func = getfield(PlainDocs, fn)
            @fact docs(fmeth(func, (Array{T, i},))) => "$(fn) $(i) $(T)"
        end

        @fact docs(fmeth(PlainDocs.lg_3)) => "lg_3"
        @fact docs(fmeth(PlainDocs.lg_4)) => "lg_4"

        @fact docs(PlainDocs.lg_T_1) => "lg_T_1"
        @fact docs(PlainDocs.lg_T_2) => "lg_T_2"

    end

    context("External docstring.") do

        @fact docs(fmeth(PlainDocs.f_35)) => "external docs\n"

    end

    context("Interface.") do

        context("Exported objects.") do

            @fact isexported(PlainDocs, PlainDocs.f_1)        => false
            @fact isexported(PlainDocs, fmeth(PlainDocs.f_1)) => false
            @fact isexported(PlainDocs, PlainDocs.T_A_1)      => false
            @fact isexported(PlainDocs, :T_TA_1)              => false
            @fact isexported(PlainDocs, :G_M_1)               => false
            @fact isexported(PlainDocs, macro_lambda("@m_1")) => false

            @fact isexported(PlainDocs, PlainDocs.f_2)        => true
            @fact isexported(PlainDocs, fmeth(PlainDocs.f_2)) => true
            @fact isexported(PlainDocs, PlainDocs.T_A_2)      => true
            @fact isexported(PlainDocs, :T_TA_2)              => true
            @fact isexported(PlainDocs, :G_M_2)               => true
            @fact isexported(PlainDocs, macro_lambda("@m_2")) => true

        end

    end

end
