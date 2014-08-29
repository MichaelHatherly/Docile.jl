info("doctest failure printing")

module Doctests

using Docile
@docstrings

export f

@doc """
```julia
f(1)
```

```julia
f(1)

```

```julia
f(-1)
```
""" ->
f(x) = sqrt(x)

end

let results = doctest(Doctests; verbose = true)
    @test results.total == 3
    @test results.pass == 1
    @test results.fail == 1
    @test results.skip == 1
end
