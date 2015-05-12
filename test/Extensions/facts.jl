require(joinpath(dirname(@__FILE__), "ExtensionTests.jl"))

import ExtensionTests
import Docile: Cache, Formats

Cache.getmeta(ExtensionTests)[:format] = Formats.PlaintextFormatter

facts("Extensions.") do

    context("!!set and !!get") do

        @fact Cache.getparsed(ExtensionTests, :set_and_get)      => "test"
        @fact Cache.getmeta(ExtensionTests, :set_and_get)[:name] => "test"

    end

    context("!!get(notset)") do

        @fact Cache.getparsed(ExtensionTests, :get_notset) => "ERROR: No metadata found for ':notset'"
        @fact_throws KeyError Cache.getmeta(ExtensionTests, :get_notset)[:notset]

    end

    context("!!setget") do

        @fact Cache.getparsed(ExtensionTests, :setget)      => "test"
        @fact Cache.getmeta(ExtensionTests, :setget)[:name] => "test"

    end

    context("!!summary") do

        @fact Cache.getparsed(ExtensionTests, :summary)         => "summary"
        @fact Cache.getmeta(ExtensionTests, :summary)[:summary] => "summary"

    end

    context("!!longform") do

        @fact Cache.getparsed(ExtensionTests, :longform) => "..."

    end

    context("!!include") do

        @fact Cache.getparsed(ExtensionTests, :includes)         => "one\n"
        @fact Cache.getparsed(ExtensionTests, :set_includes_get) => " one\n test"

    end

end
