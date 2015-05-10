require(joinpath(dirname(@__FILE__), "MacroDocs.jl"))

import MacroDocs: MacroDocs, MacroSpec

facts("MacroSpec.") do

    metadata = Docile.Interface.metadata(MacroSpec)
    entries  = Docile.Interface.entries(metadata)

    context("General.") do

        @fact length(entries) => 28

        @fact Docile.Interface.metadata(metadata) => @compat(
            Dict{Symbol, Any}(
                :format  => :md,
                :exports => Set([:MacroSpec]),
                :manual  => UTF8String[]
                )
            )

    end

    context("Methods.") do

        @fact rawdocs(entries, fmeth(MacroSpec.docs_and_meta))    => "docs_and_meta/1"
        @fact rawdocs(entries, fmeth(MacroSpec.docs_no_meta))     => "docs_no_meta/1"
        @fact rawdocs(entries, fmeth(MacroSpec.extern_docs_meta)) => ""

        @fact docsmeta(entries, :key, fmeth(MacroSpec.docs_and_meta))    => :docs_and_meta
        @fact docsmeta(entries, :key, fmeth(MacroSpec.extern_docs_meta)) => :test_case

    end

    context("Single line methods.") do

        @fact rawdocs(entries, fmeth(MacroSpec.inline_docs_meta))        => "inline_docs_meta/1"
        @fact rawdocs(entries, fmeth(MacroSpec.inline_docs_no_meta))     => "inline_docs_no_meta/1"
        @fact rawdocs(entries, fmeth(MacroSpec.inline_extern_docs_meta)) => ""

        @fact docsmeta(entries, :key, fmeth(MacroSpec.inline_docs_meta))        => :inline_docs_meta
        @fact docsmeta(entries, :key, fmeth(MacroSpec.inline_extern_docs_meta)) => :test_case

    end

    context("Generic functions.") do

        @fact rawdocs(entries, MacroSpec.inline_docs_meta)        => "inline_docs_meta"
        @fact rawdocs(entries, MacroSpec.inline_docs_no_meta)     => "inline_docs_no_meta"
        @fact rawdocs(entries, MacroSpec.inline_extern_docs_meta) => ""

        @fact docsmeta(entries, :key, MacroSpec.inline_docs_meta)        => :inline_docs_meta
        @fact docsmeta(entries, :key, MacroSpec.inline_extern_docs_meta) => :test_case

    end

    context("Types.") do

        @fact rawdocs(entries, MacroSpec.DocsAndMeta)    => "DocsAndMeta"
        @fact rawdocs(entries, MacroSpec.DocsNoMeta)     => "DocsNoMeta"
        @fact rawdocs(entries, MacroSpec.ExternDocsMeta) => ""

        @fact docsmeta(entries, :key, MacroSpec.DocsAndMeta)    => :DocsAndMeta
        @fact docsmeta(entries, :key, MacroSpec.ExternDocsMeta) => :test_case

    end

    context("Immutable types.") do

        @fact rawdocs(entries, MacroSpec.DocsAndMetaImm)    => "DocsAndMetaImm"
        @fact rawdocs(entries, MacroSpec.DocsNoMetaImm)     => "DocsNoMetaImm"
        @fact rawdocs(entries, MacroSpec.ExternDocsMetaImm) => ""

        @fact docsmeta(entries, :key, MacroSpec.DocsAndMetaImm)    => :DocsAndMetaImm
        @fact docsmeta(entries, :key, MacroSpec.ExternDocsMetaImm) => :test_case

    end

    context("Abstract types.") do

        @fact rawdocs(entries, MacroSpec.DocsAndMetaAbs)    => "DocsAndMetaAbs"
        @fact rawdocs(entries, MacroSpec.DocsNoMetaAbs)     => "DocsNoMetaAbs"
        @fact rawdocs(entries, MacroSpec.ExternDocsMetaAbs) => ""

        @fact docsmeta(entries, :key, MacroSpec.DocsAndMetaAbs)    => :DocsAndMetaAbs
        @fact docsmeta(entries, :key, MacroSpec.ExternDocsMetaAbs) => :test_case

    end

    context("Constants.") do

        @fact rawdocs(entries, :DocsAndMetaConst)    => "DocsAndMetaConst"
        @fact rawdocs(entries, :DocsNoMetaConst)     => "DocsNoMetaConst"
        @fact rawdocs(entries, :ExternDocsMetaConst) => ""

        @fact docsmeta(entries, :key, :DocsAndMetaConst)    => :DocsAndMetaConst
        @fact docsmeta(entries, :key, :ExternDocsMetaConst) => :test_case

    end

    context("Globals.") do

        @fact rawdocs(entries, :DocsAndMetaGlobal)    => "DocsAndMetaGlobal"
        @fact rawdocs(entries, :DocsNoMetaGlobal)     => "DocsNoMetaGlobal"
        @fact rawdocs(entries, :ExternDocsMetaGlobal) => ""

        @fact docsmeta(entries, :key, :DocsAndMetaGlobal)    => :DocsAndMetaGlobal
        @fact docsmeta(entries, :key, :ExternDocsMetaGlobal) => :test_case

    end

    context("Macros.") do

        @fact rawdocs(entries, macrofunc(MacroSpec, "docs_and_meta"))    => "macro_docs_and_meta"
        @fact rawdocs(entries, macrofunc(MacroSpec, "docs_no_meta"))     => "macro_docs_no_meta"
        @fact rawdocs(entries, macrofunc(MacroSpec, "extern_docs_meta")) => ""

        @fact docsmeta(entries, :key, macrofunc(MacroSpec, "docs_and_meta"))    => :macro_docs_and_meta
        @fact docsmeta(entries, :key, macrofunc(MacroSpec, "extern_docs_meta")) => :test_case

    end

    context("Modules.") do

        @fact rawdocs(entries, MacroSpec) => ""

        @fact docsmeta(entries, :key, MacroSpec) => :test_case

    end

end

facts("MacroDocs.") do

    metadata = Docile.Interface.metadata(MacroDocs)
    entries  = Docile.Interface.entries(metadata)

    context("General.") do

        @fact length(entries) => 53

        @fact Docile.Interface.metadata(metadata) => @compat(
            Dict{Symbol, Any}(
                :format => :md,
                :exports => Set([:MacroDocs]),
                :manual  => ["../../docs/manual.md"]
                )
            )

    end

    context("Functions.") do

        @fact rawdocs(entries, fmeth(MacroDocs.f_1)) => "f_1"
        @fact rawdocs(entries, fmeth(MacroDocs.f_2)) => "f_2"
        @fact rawdocs(entries, fmeth(MacroDocs.f_3)) => "f_3"
        @fact rawdocs(entries, fmeth(MacroDocs.f_4)) => "f_4"

        @fact rawdocs(entries, fmeth(MacroDocs.f_5))  => "f_5"
        @fact rawdocs(entries, fmeth(MacroDocs.f_6))  => "f_6"
        @fact rawdocs(entries, fmeth(MacroDocs.f_7))  => "f_7"
        @fact rawdocs(entries, fmeth(MacroDocs.f_8))  => "f_8"
        @fact rawdocs(entries, fmeth(MacroDocs.f_9))  => "f_9"
        @fact rawdocs(entries, fmeth(MacroDocs.f_10)) => "f_10"
        @fact rawdocs(entries, fmeth(MacroDocs.f_11)) => "f_11"
        @fact rawdocs(entries, fmeth(MacroDocs.f_12)) => "f_12"
        @fact rawdocs(entries, fmeth(MacroDocs.f_13)) => "f_13"
        @fact rawdocs(entries, fmeth(MacroDocs.f_14)) => "f_14"
        @fact rawdocs(entries, fmeth(MacroDocs.f_15)) => "f_15"
        @fact rawdocs(entries, fmeth(MacroDocs.f_16)) => "f_16"
        @fact rawdocs(entries, fmeth(MacroDocs.f_17)) => "f_17"
        @fact rawdocs(entries, fmeth(MacroDocs.f_18)) => "f_18"
        @fact rawdocs(entries, fmeth(MacroDocs.f_19)) => "f_19"
        @fact rawdocs(entries, fmeth(MacroDocs.f_20)) => "f_20"
        @fact rawdocs(entries, fmeth(MacroDocs.f_21)) => "f_21"
        @fact rawdocs(entries, fmeth(MacroDocs.f_22)) => "f_22"
        @fact rawdocs(entries, fmeth(MacroDocs.f_23)) => "f_23"
        @fact rawdocs(entries, fmeth(MacroDocs.f_24)) => "f_24"
        @fact rawdocs(entries, fmeth(MacroDocs.f_25)) => "f_25"
        @fact rawdocs(entries, fmeth(MacroDocs.f_26)) => "f_26"
        @fact rawdocs(entries, fmeth(MacroDocs.f_27)) => "f_27"
        @fact rawdocs(entries, fmeth(MacroDocs.f_28)) => "f_28"
        @fact rawdocs(entries, fmeth(MacroDocs.f_29)) => "f_29"

        @fact rawdocs(entries, MacroDocs.f_1) => "g_f_1"
        @fact rawdocs(entries, MacroDocs.f_2) => "g_f_2"

        @fact rawdocs(entries, MacroDocs.f_30)        => "g_f_30"
        @fact rawdocs(entries, fmeth(MacroDocs.f_30)) => "f_30"

        @fact rawdocs(entries, MacroDocs.f_31)        => "g_f_31"
        @fact rawdocs(entries, fmeth(MacroDocs.f_31)) => "f_31"

        @fact docsmeta(entries, :returns, MacroDocs.f_31)        => Int
        @fact docsmeta(entries, :returns, fmeth(MacroDocs.f_31)) => Bool

        @fact rawdocs(entries, fmeth(MacroDocs.f_36)) => "f_36"
        @fact rawdocs(entries, fmeth(MacroDocs.f_37)) => "f_37"

    end

    context("Globals.") do

        @fact rawdocs(entries, :G_M_1) => "G_M_1"
        @fact rawdocs(entries, :G_M_2) => "G_M_2"

        @fact rawdocs(entries, :G_C_1) => "G_C_1"
        @fact rawdocs(entries, :G_C_2) => "G_C_2"

    end

    context("Macros.") do

        @fact rawdocs(entries, macrofunc(MacroDocs, "m_1")) => "m_1"
        @fact rawdocs(entries, macrofunc(MacroDocs, "m_2")) => "m_2"

    end

    context("Types.") do

        @fact rawdocs(entries, MacroDocs.T_A_1) => "T_A_1"
        @fact rawdocs(entries, MacroDocs.T_A_2) => "T_A_2"

        @fact rawdocs(entries, MacroDocs.T_M_1) => "T_M_1"
        @fact rawdocs(entries, MacroDocs.T_M_2) => "T_M_2"

        @fact rawdocs(entries, MacroDocs.T_I_1) => "T_I_1"
        @fact rawdocs(entries, MacroDocs.T_I_2) => "T_I_2"

    end

end
