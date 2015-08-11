include(joinpath(dirname(@__FILE__), "MetadataSyntax.jl"))
include(joinpath(dirname(@__FILE__), "UndefinedMetaMacro.jl"))
include(joinpath(dirname(@__FILE__), "UnmatchedBrackets.jl"))
include(joinpath(dirname(@__FILE__), "RawMetaMacros.jl"))

Docile.Cache.register_module(joinpath(dirname(@__FILE__), "MetadataSyntax.jl"))
Docile.Cache.register_module(joinpath(dirname(@__FILE__), "UndefinedMetaMacro.jl"))
Docile.Cache.register_module(joinpath(dirname(@__FILE__), "UnmatchedBrackets.jl"))
Docile.Cache.register_module(joinpath(dirname(@__FILE__), "RawMetaMacros.jl"))

import MetadataSyntax, UndefinedMetaMacro, UnmatchedBrackets, RawMetaMacros
import Docile: Cache, Formats

Cache.getmeta(MetadataSyntax)[:format] = Formats.PlaintextFormatter

facts("Formats.") do

    context("Undefined MetaMacro.") do

        @fact_throws ErrorException Docile.Cache.getparsed(qs(UndefinedMetaMacro, :undefined)...)

    end

    context("Unmatched Brackets.") do

        @fact_throws ParseError Docile.Cache.getparsed(qs(UnmatchedBrackets, :unmatched_brackets)...)

    end

    context("No meta-syntax.") do

        @fact Cache.getparsed(qs(MetadataSyntax, :no_meta_syntax)...) --> "No meta-syntax."

        @fact_throws KeyError Cache.getmeta(qs(MetadataSyntax, :no_meta_syntax)...)[:no_meta_syntax]

    end

    context("\\!!var.") do

        @fact Cache.getparsed(qs(MetadataSyntax, :one_backslash_escape)...) -->
            "One backslash is skipped and treated like a normal meta syntax."

        @fact Cache.getmeta(qs(MetadataSyntax, :one_backslash_escape)...)[:one_backslash_escape] -->
            "One backslash is skipped and treated like a normal meta syntax."

    end

    context("!! var.") do

        @fact Cache.getparsed(qs(MetadataSyntax, :space_between_backslash_metaname)...) -->
            "!! var(space_between_backslash_metaname:Space between double ! and metaname is not a metasyntax.)"

        @fact_throws(
            KeyError,
            Cache.getmeta(qs(MetadataSyntax, :space_between_backslash_metaname)...)[:space_between_backslash_metaname]
            )

    end

    context("!!var (.") do

        @fact Cache.getparsed(qs(MetadataSyntax, :space_between_metaname_bracket)...) -->
            "!!var (space_between_metaname_bracket:Space between metaname and bracket is not a metasyntax.)"

        @fact_throws(
            KeyError,
            Cache.getmeta(qs(MetadataSyntax, :space_between_metaname_bracket)...)[:space_between_metaname_bracket]
            )

    end

    context("Brackets within meta: [MIT]().") do

        @fact Cache.getparsed(qs(MetadataSyntax, :brackets_within_meta)...) -->
            "[MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md)"

        @fact Cache.getmeta(qs(MetadataSyntax, :brackets_within_meta)...)[:license] -->
            "[MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md)"

    end

    context("!!var(笔者:所以不多说了)") do

        @fact Cache.getparsed(qs(MetadataSyntax, :chinese_unicode)...) -->
            "所以不多说了"

        @fact Cache.getmeta(qs(MetadataSyntax, :chinese_unicode)...)[:笔者] -->
            "所以不多说了"

    end

    context("\\\\!!var") do

        @fact Cache.getparsed(qs(MetadataSyntax, :backslash_escaped_meta)...) -->
            "!!var(russian:бежал мета)"

        @fact_throws(
            KeyError,
            Cache.getmeta(qs(MetadataSyntax, :backslash_escaped_meta)...)[:russian]
            )

    end

    context("Escaped nested metamacros.") do

        @fact Cache.getparsed(qs(MetadataSyntax, :backslash_escaped_nested_meta)...) -->
            "!!var(unicode_meta_in_meta:所以不多说了 бежал мета)"

        @fact_throws(
            KeyError,
            Cache.getmeta(qs(MetadataSyntax, :backslash_escaped_nested_meta)...)[:unicode_meta_in_meta]
            )

        @fact Cache.getmeta(qs(MetadataSyntax, :backslash_escaped_nested_meta)...)[:笔者_inner] -->
            "бежал мета"

    end

    context("Raw Metamacros.") do

        @fact Cache.getparsed(qs(RawMetaMacros, :raw_metamacro)...) -->
            "!!undefined()"

        @fact Cache.getparsed(qs(RawMetaMacros, :nested_metamacro)...) -->
            "nestable"

        @fact Cache.getmeta(qs(RawMetaMacros, :nested_metamacro)...)[:metamacro_type] -->
            "nestable"

    end

end
