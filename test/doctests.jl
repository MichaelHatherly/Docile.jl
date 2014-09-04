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

let results = doctest(Doctests)
    @test length(passed(results)) == 1
    @test length(failed(results)) == 1
    @test length(skipped(results)) == 1
    
    buf = IOBuffer()
    writemime(buf, "text/plain", results)
end
