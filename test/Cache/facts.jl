require(joinpath(dirname(@__FILE__), "Example.jl"))

import Example

import Docile: Cache

facts("Example.") do

    context("General.") do

         objects = Cache.objects(Example)
        for obj in objects
            Cache.addmeta(Example, obj, :newkey, 500)
            @fact Docile.Cache.getmeta(Example, obj)[:newkey] => 500
            @fact_throws ArgumentError Cache.addmeta(Example, obj, :newkey, 0)

        end

    end

end
