require(joinpath(dirname(@__FILE__), "MetadataSyntax.jl"))
require(joinpath(dirname(@__FILE__), "UndefinedMetaMacro.jl"))
require(joinpath(dirname(@__FILE__), "UnmatchedBrackets.jl"))

import MetadataSyntax, UndefinedMetaMacro, UnmatchedBrackets
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

    context("brackets within meta: [MIT]()") do

        @fact Cache.getparsed(MetadataSyntax, :brackets_within_meta)         => "[MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md)"
        @fact Cache.getmeta(MetadataSyntax, :brackets_within_meta)[:license] => "[MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md)"

    end

    context("!!setget(笔者:所以不多说了)") do

        @fact Cache.getparsed(MetadataSyntax, :chinese_unicode)     => "所以不多说了"
        @fact Cache.getmeta(MetadataSyntax, :chinese_unicode)[:笔者] => "所以不多说了"

    end

    context("\\\\!!setget") do

        @fact Cache.getparsed(MetadataSyntax, :backslash_escaped_meta)         => "!!setget(russian:бежал мета)"
        @fact_throws KeyError Cache.getmeta(MetadataSyntax, :backslash_escaped_meta)[:russian]

    end

    context("!!setget(meta_in_meta:Here we have an !!setget(inner:inner meta))") do

        @fact Cache.getparsed(MetadataSyntax, :meta_in_meta)              => "Here we have an inner meta"
        @fact Cache.getmeta(MetadataSyntax, :meta_in_meta)[:meta_in_meta] => "Here we have an inner meta"
        @fact Cache.getmeta(MetadataSyntax, :meta_in_meta)[:inner]        => "inner meta"

    end

    context("unicode meta_in_meta") do

        @fact Cache.getparsed(MetadataSyntax, :unicode_meta_in_meta)                      => "所以不多说了 бежал мета"
        @fact Cache.getmeta(MetadataSyntax, :unicode_meta_in_meta)[:unicode_meta_in_meta] => "所以不多说了 бежал мета"
        @fact Cache.getmeta(MetadataSyntax, :unicode_meta_in_meta)[:笔者_inner]            => "бежал мета"

    end

    context("deep_nested_meta: 6 levels") do

        @fact Cache.getparsed(MetadataSyntax, :deep_nested_meta) => "Outer\nLevel1\nLevel2\nLevel3\nLevel4\nLevel5\nLevel6\n"

        @fact Cache.getmeta(MetadataSyntax, :deep_nested_meta)[:outer]  => "Outer\nLevel1\nLevel2\nLevel3\nLevel4\nLevel5\nLevel6"
        @fact Cache.getmeta(MetadataSyntax, :deep_nested_meta)[:level1] => "Level1\nLevel2\nLevel3\nLevel4\nLevel5\nLevel6"
        @fact Cache.getmeta(MetadataSyntax, :deep_nested_meta)[:level2] => "Level2\nLevel3\nLevel4\nLevel5\nLevel6"
        @fact Cache.getmeta(MetadataSyntax, :deep_nested_meta)[:level3] => "Level3\nLevel4\nLevel5\nLevel6"
        @fact Cache.getmeta(MetadataSyntax, :deep_nested_meta)[:level4] => "Level4\nLevel5\nLevel6"
        @fact Cache.getmeta(MetadataSyntax, :deep_nested_meta)[:level5] => "Level5\nLevel6"
        @fact Cache.getmeta(MetadataSyntax, :deep_nested_meta)[:level6] => "Level6"

    end

    context("backslash_escaped_nested_meta") do

        @fact Cache.getparsed(MetadataSyntax, :backslash_escaped_nested_meta) => "!!setget(unicode_meta_in_meta:所以不多说了 бежал мета)"
        @fact_throws KeyError Cache.getmeta(MetadataSyntax, :backslash_escaped_nested_meta)[:unicode_meta_in_meta]
        @fact Cache.getmeta(MetadataSyntax, :backslash_escaped_nested_meta)[:笔者_inner] => "бежал мета"

    end

end
