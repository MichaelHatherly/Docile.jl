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
f(-1)
```
""" ->
f(x) = sqrt(x)

end

doctest(Doctests; verbose = true)
