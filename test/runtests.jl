using Docile
using Base.Test

const PACKAGE_NAME = "DocileTests"

const DOCS = """
# $(PACKAGE_NAME)

## test_func_1{T <: Number}(a::Float64, b::Array{T,2})

Docile function tests.

Example:

    julia> test_func_1(1.0, [2 2; 3 1])

## @test_macro_1(a, b, c)

Docile function tests.
"""

## Run Docile on itself –––––––––––––––––––––––––––––––––––––––––––––––––––––––

Docile.build("Docile")

## Errors –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@test_throws ErrorException Docile.build(PACKAGE_NAME)
@test_throws ErrorException Docile.remove(PACKAGE_NAME)
@test_throws ErrorException Docile.init(PACKAGE_NAME)

## Package creation and documentation generation ––––––––––––––––––––––––––––––

Pkg.generate(PACKAGE_NAME, "MIT")
atexit(() -> Pkg.rm(PACKAGE_NAME))

Docile.init(PACKAGE_NAME)

Docile.build()
Docile.build(PACKAGE_NAME)

open(joinpath(Pkg.dir(PACKAGE_NAME), "doc", "help", "docs.md"), "w") do f
    write(f, DOCS)
end

Docile.patch!()
Base.Help.init_help()

## Clean up –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

Docile.remove(PACKAGE_NAME)
