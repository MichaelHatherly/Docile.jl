require(joinpath(dirname(@__FILE__), "MetadataSyntax.jl"))

using MetadataSyntax

facts("Formats.") do

    allparsed = Docile.Cache.getparsed(MetadataSyntax)
    context("MetadataSyntax.") do

        @fact allparsed[fmeth(MetadataSyntax.example1)] => "example1: unicode text: Água é uma substância química cujas moléculas são formadas por dois átomos de hidrogênio e um de oxigênio."
        @fact allparsed[fmeth(MetadataSyntax.example2)] => "example2: unicode meta txt normal: Just normal text."
        @fact allparsed[fmeth(MetadataSyntax.example3)] => "example3: unicode meta and txt: Água é uma substância química cujas moléculas são formadas por dois átomos de hidrogênio e um de oxigênio."

    end

end
