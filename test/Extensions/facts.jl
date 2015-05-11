require(joinpath(dirname(@__FILE__), "ExtensionTests.jl"))

import ExtensionTests
import Docile: Cache, Formats

Cache.getmeta(ExtensionTests)[:format] = Formats.PlaintextFormatter

facts("Extensions.") do

    context("!!set and !!get") do

        @fact Cache.getparsed(ExtensionTests, :set_and_get)      => "test"
        @fact Cache.getmeta(ExtensionTests, :set_and_get)[:name] => "test"

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
