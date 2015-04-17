include("module.jl")

meta = MacroDocs.__METADATA__
docs(obj)  = meta.entries[obj].docs.data
entry(obj) = meta.entries[obj]

fmeth(obj) = first(methods(obj))
fmeth(obj, T) = first(methods(obj, T))

facts("Macro docstrings.") do

    context("Basics.") do

        @fact length(meta.entries) => 71

        @fact meta.data => @compat Dict{Symbol, Any}(
            :format => :md,
            :manual => ["../../docs/manual.md"],
            :root   => dirname(@__FILE__)
            )

        @fact meta.modname => MacroDocs

    end

    context("Methods.") do

        for i = 1:29
            fn = string("f_", i)
            @fact docs(fmeth(getfield(MacroDocs, symbol(fn)))) => fn
        end

        @fact docs(fmeth(MacroDocs.f_30, Docile.tup(Any,))) => "f_30"
        @fact docs(fmeth(MacroDocs.f_31, Docile.tup(Any,))) => "f_31"

        @fact entry(fmeth(MacroDocs.f_31, Docile.tup(Any,))).data[:returns] => (Bool,)

        @fact docs(fmeth(Base.getindex, Docile.tup(MacroDocs.Foo, Integer))) => "Base.getindex"
        @fact docs(fmeth(Base.Meta.show_sexpr, Docile.tup(MacroDocs.Foo,)))  => "Base.Meta.show_sexpr"

    end

    context("Functions.") do

        @fact docs(MacroDocs.f_1) => "g_f_1"
        @fact docs(MacroDocs.f_2) => "g_f_2"

        @fact docs(MacroDocs.f_30) => "g_f_30"
        @fact docs(MacroDocs.f_31) => "g_f_31"

        @fact entry(MacroDocs.f_31).data[:returns] => (Bool,)

        @fact entry(MacroDocs.f_32).data[:result] => docs(MacroDocs.f_32)
        @fact entry(MacroDocs.f_33).data[:result] => docs(MacroDocs.f_33)
        @fact entry(MacroDocs.f_34).data[:result] => docs(MacroDocs.f_34)
        @fact entry(MacroDocs.f_35).data[:result] => docs(MacroDocs.f_35)

    end

    context("Macros.") do

        @fact docs(getfield(MacroDocs, symbol("@m_1"))) => "m_1"
        @fact docs(getfield(MacroDocs, symbol("@m_2"))) => "m_2"

    end

    context("Types.") do

        @fact docs(MacroDocs.T_A_1) => "T_A_1"
        @fact docs(MacroDocs.T_A_2) => "T_A_2"

        @fact docs(MacroDocs.T_M_1) => "T_M_1"
        @fact docs(MacroDocs.T_M_2) => "T_M_2"

        @fact docs(MacroDocs.T_I_1) => "T_I_1"
        @fact docs(MacroDocs.T_I_2) => "T_I_2"

    end

    context("Global variables.") do

        @fact docs(:G_M_1) => "G_M_1"
        @fact docs(:G_M_2) => "G_M_2"
        @fact docs(:G_C_1) => "G_C_1"
        @fact docs(:G_C_2) => "G_C_2"

    end

    context("Loop generated docstrings.") do

        for i = 1:2, T = [Integer, Float64], fn = [:lg_1, :lg_2]
            func = getfield(MacroDocs, fn)
            @fact docs(fmeth(func, Docile.tup(Array{T, i},))) => "$(fn) $(i) $(T)"
        end

        @fact docs(fmeth(MacroDocs.lg_3)) => "lg_3"
        @fact docs(fmeth(MacroDocs.lg_4)) => "lg_4"

    end
end
