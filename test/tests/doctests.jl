results = doctest(Docile)
@test length(failed(results)) == 0

results = doctest(Docile.Interface)
@test length(failed(results)) == 0
