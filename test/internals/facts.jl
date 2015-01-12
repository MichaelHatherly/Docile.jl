module InternalTests

using Docile, Docile.Interface, FactCheck

facts("Internals.") do
    context("Metadata.") do
        @fact copy(metadata(Docile))           => metadata(Docile)
        @fact copy(metadata(Docile.Interface)) => metadata(Docile.Interface)
    end
end

end
