
include(joinpath(dirname(@__FILE__), "PlainDocs.jl"))
include(joinpath(dirname(@__FILE__), "ExampleAside.jl"))
include(joinpath(dirname(@__FILE__), "NoNewline.jl"))

Docile.Cache.register_module(joinpath(dirname(@__FILE__), "PlainDocs.jl"))
Docile.Cache.register_module(joinpath(dirname(@__FILE__), "ExampleAside.jl"))
Docile.Cache.register_module(joinpath(dirname(@__FILE__), "NoNewline.jl"))

import PlainDocs
import ExampleAside
import NoNewline

facts("PlainDocs.") do

    metadata = Docile.Interface.metadata(PlainDocs)
    entries  = Docile.Interface.entries(metadata)

    context("General.") do

        @fact length(entries) --> 87

        @fact Docile.Interface.metadata(metadata) --> @compat(
            Dict{Symbol, Any}(
                :format  => :md,
                :exports => Set([:PlainDocs]),
                :manual  => UTF8String[],
                )
            )

        package_data = Docile.Cache.getpackage(PlainDocs)
        module_data  = Docile.Cache.getmodule(PlainDocs)

        @fact Docile.Cache.getmeta(package_data) --> @compat(
            Dict{Symbol, Any}(
                :format => Docile.Formats.MarkdownFormatter,
                )
            )
        @fact Docile.Cache.getmeta(module_data) --> @compat(
            Dict{Symbol, Any}(
                :exports => Set([:PlainDocs]),
                )
            )

    end

    context("Functions.") do

        @fact rawdocs(entries, fmeth(PlainDocs.f_0)) --> "f_0/0"
        @fact rawdocs(entries, fmeth(PlainDocs.f_1)) --> "f_1/1"
        @fact rawdocs(entries, fmeth(PlainDocs.f_2)) --> "f_2/1"
        @fact rawdocs(entries, fmeth(PlainDocs.f_3)) --> "f_3/1"
        @fact rawdocs(entries, fmeth(PlainDocs.f_4)) --> "f_4/1"

        @fact rawdocs(entries, fmeth(PlainDocs.f_5)) --> "f_5"
        @fact rawdocs(entries, fmeth(PlainDocs.f_6)) --> "f_6"
        @fact rawdocs(entries, fmeth(PlainDocs.f_7)) --> "f_7"
        @fact rawdocs(entries, fmeth(PlainDocs.f_8)) --> "f_8"
        @fact rawdocs(entries, fmeth(PlainDocs.f_9)) --> "f_9"
        @fact rawdocs(entries, fmeth(PlainDocs.f_10)) --> "f_10"
        @fact rawdocs(entries, fmeth(PlainDocs.f_11)) --> "f_11"
        @fact rawdocs(entries, fmeth(PlainDocs.f_12)) --> "f_12"
        @fact rawdocs(entries, fmeth(PlainDocs.f_13)) --> "f_13"
        @fact rawdocs(entries, fmeth(PlainDocs.f_14)) --> "f_14"
        @fact rawdocs(entries, fmeth(PlainDocs.f_15)) --> "f_15"
        @fact rawdocs(entries, fmeth(PlainDocs.f_16)) --> "f_16"
        @fact rawdocs(entries, fmeth(PlainDocs.f_17)) --> "f_17"
        @fact rawdocs(entries, fmeth(PlainDocs.f_18)) --> "f_18"
        @fact rawdocs(entries, fmeth(PlainDocs.f_19)) --> "f_19"

        @fact rawdocs(entries, fmeth(PlainDocs.f_20)) --> "f_20"
        @fact rawdocs(entries, fmeth(PlainDocs.f_21)) --> "f_21"
        @fact rawdocs(entries, fmeth(PlainDocs.f_22)) --> "f_22"
        @fact rawdocs(entries, fmeth(PlainDocs.f_23)) --> "f_23"
        @fact rawdocs(entries, fmeth(PlainDocs.f_24)) --> "f_24"
        @fact rawdocs(entries, fmeth(PlainDocs.f_25)) --> "f_25"
        @fact rawdocs(entries, fmeth(PlainDocs.f_26)) --> "f_26"
        @fact rawdocs(entries, fmeth(PlainDocs.f_27)) --> "f_27"
        @fact rawdocs(entries, fmeth(PlainDocs.f_28)) --> "f_28"
        @fact rawdocs(entries, fmeth(PlainDocs.f_29)) --> "f_29"

        @fact rawdocs(entries, fmeth(PlainDocs.f_30)) --> "f_30"
        @fact rawdocs(entries, fmeth(PlainDocs.f_31)) --> "f_31"
        @fact rawdocs(entries, fmeth(PlainDocs.f_32)) --> "f_32"
        @fact rawdocs(entries, fmeth(PlainDocs.f_33)) --> "f_33"

        @fact rawdocs(entries, PlainDocs.f_1) --> "g_f_1"
        @fact rawdocs(entries, PlainDocs.f_2) --> "g_f_2"

        @fact rawdocs(entries, PlainDocs.f_34) --> "f_34"
        @fact rawdocs(entries, PlainDocs.f_35) --> "f_35"

        for m in methods(PlainDocs.f_36)
            @fact rawdocs(entries, m) --> "f_36"
        end

        @fact rawdocs(entries, PlainDocs.f_37)  --> "f_37"
        @fact rawdocs(entries, PlainDocs.f_37!) --> "f_37"

        @fact rawdocs(entries, fmeth(PlainDocs.f_38)) --> "f_38/f_39"
        @fact rawdocs(entries, fmeth(PlainDocs.f_39)) --> "f_38/f_39"

        @fact rawdocs(entries, PlainDocs.f_40) --> "f_40"
        @fact rawdocs(entries, PlainDocs.f_40!) --> "f_40"

        @fact rawdocs(entries, meth(PlainDocs.f_41, PlainDocs.tup())) --> "f_41/f_42"
        @fact rawdocs(entries, meth(PlainDocs.f_41, PlainDocs.tup(Any))) --> "f_41/f_42"
        @fact rawdocs(entries, meth(PlainDocs.f_42, PlainDocs.tup())) --> "f_41/f_42"
        @fact rawdocs(entries, meth(PlainDocs.f_42, PlainDocs.tup(Any))) --> "f_41/f_42"

        @fact rawdocs(entries, meth(PlainDocs.f_43, PlainDocs.tup(Any, Any, Any))) --> "f_43"

        @fact rawdocs(entries, PlainDocs.f_44) --> "f_44, f_45"
        @fact rawdocs(entries, PlainDocs.f_45) --> "f_44, f_45"

    end

    context("Globals.") do

        @fact rawdocs(entries, :G_M_1) --> "G_M_1"
        @fact rawdocs(entries, :G_M_2) --> "G_M_2"

        @fact rawdocs(entries, :G_C_1) --> "G_C_1"
        @fact rawdocs(entries, :G_C_2) --> "G_C_2"

    end

    context("Macros.") do

        @fact rawdocs(entries, macrofunc(PlainDocs, "m_1")) --> "m_1"
        @fact rawdocs(entries, macrofunc(PlainDocs, "m_2")) --> "m_2"

    end

    context("Types.") do

        @fact rawdocs(entries, PlainDocs.T_A_1) --> "T_A_1"
        @fact rawdocs(entries, PlainDocs.T_A_2) --> "T_A_2"

        @fact rawdocs(entries, :T_TA_1) --> "T_TA_1"
        @fact rawdocs(entries, :T_TA_2) --> "T_TA_2"

        @fact rawdocs(entries, PlainDocs.T_M_1) --> "T_M_1"
        @fact rawdocs(entries, PlainDocs.T_M_2) --> "T_M_2"

        @fact rawdocs(entries, PlainDocs.T_I_1) --> "T_I_1"
        @fact rawdocs(entries, PlainDocs.T_I_2) --> "T_I_2"

        @fact rawdocs(entries, PlainDocs.T_IC_1) --> "T_IC_1"

        @fact rawdocs(entries, meth(PlainDocs.T_IC_1, PlainDocs.tup())) --> "T_IC_1/0"
        @fact rawdocs(entries, meth(PlainDocs.T_IC_1, PlainDocs.tup(Any))) --> "T_IC_1/1"

        @fact rawdocs(entries, PlainDocs.T_IC_2) --> "T_IC_2"

        @fact rawdocs(entries,
                      meth(PlainDocs.T_IC_2{Any},
                           PlainDocs.tup())
                      ) --> "T_IC_2/0"
        @fact rawdocs(entries,
                      meth(PlainDocs.T_IC_2{Any},
                           PlainDocs.tup(Any))
                      ) --> "T_IC_2/1-2"
        @fact rawdocs(entries,
                      meth(PlainDocs.T_IC_2{Any},
                           PlainDocs.tup(Any, Any))
                      ) --> "T_IC_2/1-2"

        @fact rawdocs(entries, PlainDocs.T_IC_3) --> "T_IC_3"

        @fact rawdocs(entries,
                      meth(PlainDocs.T_IC_3{Real},
                           PlainDocs.tup(Integer)
                           )
                      ) --> "T_IC_3/1"
        @fact rawdocs(entries,
                      meth(PlainDocs.T_IC_3{Real},
                           PlainDocs.tup(Real,Real)
                           )
                      ) --> "T_IC_3/2"
        @fact rawdocs(entries,
                      meth(PlainDocs.T_IC_3{Real},
                           PlainDocs.tup(Type{Matrix{Real}},
                                         Vector{Real},
                                         Vararg{Int})
                           )
                      ) --> "T_IC_3/3"

        @fact rawdocs(entries, PlainDocs.BT_1)             --> "BT_1"
        @fact docsmeta(entries, :category, PlainDocs.BT_1) --> :bitstype

        @fact rawdocs(entries, PlainDocs.BT_2)             --> "BT_2"
        @fact docsmeta(entries, :category, PlainDocs.BT_2) --> :bitstype

    end

end

facts("Base") do

    context("Cache Base and it's submodules.") do

        @fact isa(Docile.Cache.getparsed(Base), ObjectIdDict) --> true

    end

end

## 'function <name> end' syntax tests. ##

if VERSION >= v"0.4-dev+4989"
    include(joinpath(dirname(@__FILE__), "FunctionSyntax", "FunctionSyntax.jl"))
    Docile.Cache.register_module(joinpath(dirname(@__FILE__), "FunctionSyntax", "FunctionSyntax.jl"))
    import FunctionSyntax

    facts("Function Syntax.") do
        metadata = Docile.Interface.metadata(FunctionSyntax)
        entries  = Docile.Interface.entries(metadata)

        @fact length(entries) --> 2

        @fact Docile.Interface.metadata(metadata) --> @compat(
            Dict{Symbol, Any}(
                :format  => :md,
                :exports => Set([:FunctionSyntax]),
                :manual  => UTF8String[]
                )
            )

        @fact rawdocs(entries, FunctionSyntax.f_1) --> "f_1"
        @fact rawdocs(entries, FunctionSyntax.f_2) --> "f_2\n"

        @fact docsmeta(entries, :category, FunctionSyntax.f_1) --> :function
        @fact docsmeta(entries, :category, FunctionSyntax.f_2) --> :function
    end
end

facts("Misc.") do

    context("Module field") do

        obj = Docile.Cache.objects(ExampleAside)[1]
        @fact obj.mod --> ExampleAside

    end

    context("No Newline.") do

        obj = Docile.Cache.objects(NoNewline)[1]
        @fact Docile.Cache.getraw(NoNewline, obj) --> "f"

    end

end
