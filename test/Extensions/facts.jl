include(joinpath(dirname(@__FILE__), "ExtensionTests.jl"))

Docile.Cache.register_module(joinpath(dirname(@__FILE__), "ExtensionTests.jl"))

import ExtensionTests
import Docile: Cache, Formats

Cache.getmeta(ExtensionTests)[:format] = Formats.PlaintextFormatter

facts("Extensions.") do

    context("!!set and !!get") do

        @fact Cache.getparsed(qs(ExtensionTests, :set_and_get)...)      => "test"
        @fact Cache.getmeta(qs(ExtensionTests, :set_and_get)...)[:name] => "test"

    end

    context("!!var") do

        @fact Cache.getparsed(qs(ExtensionTests, :var)...)      => "test"
        @fact Cache.getmeta(qs(ExtensionTests, :var)...)[:name] => "test"

    end

    context("!!summary") do

        @fact Cache.getparsed(qs(ExtensionTests, :summary)...)         => "summary"
        @fact Cache.getmeta(qs(ExtensionTests, :summary)...)[:summary] => "summary"

    end

    context("!!longform") do

        @fact Cache.getparsed(qs(ExtensionTests, :longform)...) => "..."

    end

    context("!!include") do

        @fact Cache.getparsed(qs(ExtensionTests, :includes)...)         => "one\n"
        @fact Cache.getparsed(qs(ExtensionTests, :set_includes_get)...) => " one\n test"

    end

    context("!!include with metas") do

        @fact Cache.getparsed(qs(ExtensionTests, :includes_nested)...) =>
            string("Text with Outer\nLevel1\nLevel2\nLevel3\nLevel4\nLevel5\nLevel6\n\n",
                   "Some unicode 所以不多说了 бежал мета\n Get the inner again: бежал мета")

        @fact Cache.getmeta(qs(ExtensionTests, :includes_nested)...)[:level6] => "Level6"

    end

end
