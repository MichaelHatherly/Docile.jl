require(joinpath(dirname(@__FILE__), "MetadataSyntax.jl"))
require(joinpath(dirname(@__FILE__), "UndefinedMetaMacro.jl"))
require(joinpath(dirname(@__FILE__), "UnmatchedBrackets.jl"))
require(joinpath(dirname(@__FILE__), "RawMetaMacros.jl"))

import MetadataSyntax, UndefinedMetaMacro, UnmatchedBrackets, RawMetaMacros
import Docile: Cache, Formats

Cache.getmeta(MetadataSyntax)[:format] = Formats.PlaintextFormatter

facts("Formats.") do

    context("Undefined MetaMacro.") do

        @fact_throws ErrorException Docile.Cache.getparsed(UndefinedMetaMacro, :undefined)

    end

    context("Unmatched Brackets.") do

        @fact_throws ParseError Docile.Cache.getparsed(UnmatchedBrackets, :unmatched_brackets)

    end

    context("No meta-syntax.") do

        @fact Cache.getparsed(MetadataSyntax, :no_meta_syntax) => "No meta-syntax."
        @fact_throws KeyError Cache.getmeta(MetadataSyntax, :no_meta_syntax)[:no_meta_syntax]

    end

    context("\\!!setget.") do
        @fact Cache.getparsed(MetadataSyntax, :one_backslash_escape)                        => "One backslash is skipped and treated like a normal meta syntax."
        @fact Cache.getmeta(MetadataSyntax, :one_backslash_escape)[:one_backslash_escape]   => "One backslash is skipped and treated like a normal meta syntax."

    end

    context("!! setget.") do

        @fact Cache.getparsed(MetadataSyntax, :space_between_backslash_metaname) => "!! setget(space_between_backslash_metaname:Space between double ! and metaname is not a metasyntax.)"
        @fact_throws KeyError Cache.getmeta(MetadataSyntax, :space_between_backslash_metaname)[:space_between_backslash_metaname]

    end

    context("!!setget (.") do

        @fact Cache.getparsed(MetadataSyntax, :space_between_metaname_bracket) => "!!setget (space_between_metaname_bracket:Space between metaname and bracket is not a metasyntax.)"
        @fact_throws KeyError Cache.getmeta(MetadataSyntax, :space_between_metaname_bracket)[:space_between_metaname_bracket]

    end

    context("Brackets within meta: [MIT]().") do

        @fact Cache.getparsed(MetadataSyntax, :brackets_within_meta)         => "[MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md)"
        @fact Cache.getmeta(MetadataSyntax, :brackets_within_meta)[:license] => "[MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md)"

    end

    context("!!setget(笔者:所以不多说了)") do

        @fact Cache.getparsed(MetadataSyntax, :chinese_unicode)     => "所以不多说了"
        @fact Cache.getmeta(MetadataSyntax, :chinese_unicode)[:笔者] => "所以不多说了"

    end

    context("\\\\!!setget") do

        @fact Cache.getparsed(MetadataSyntax, :backslash_escaped_meta)  => "!!setget(russian:бежал мета)"
        @fact_throws KeyError Cache.getmeta(MetadataSyntax, :backslash_escaped_meta)[:russian]

    end

    context("Escaped nested metamacros.") do

        @fact Cache.getparsed(MetadataSyntax, :backslash_escaped_nested_meta) => "!!setget(unicode_meta_in_meta:所以不多说了 бежал мета)"
        @fact_throws KeyError Cache.getmeta(MetadataSyntax, :backslash_escaped_nested_meta)[:unicode_meta_in_meta]
        @fact Cache.getmeta(MetadataSyntax, :backslash_escaped_nested_meta)[:笔者_inner] => "бежал мета"

    end

    context("Raw Metamacros.") do

        @fact Cache.getparsed(RawMetaMacros, :raw_metamacro)                     => "!!undefined()"
        @fact Cache.getparsed(RawMetaMacros, :nested_metamacro)                  => "nestable"
        @fact Cache.getmeta(RawMetaMacros,   :nested_metamacro)[:metamacro_type] => "nestable"

    end

end
