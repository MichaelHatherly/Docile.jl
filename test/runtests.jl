using Docile
using Base.Test

PACKAGE_NAME = "Docile"
PKG_DIR      = Pkg.dir(PACKAGE_NAME)
DOC_DIR      = joinpath(PKG_DIR, "doc")
CACHE_DIR    = joinpath(PKG_DIR, "cache")

# Clean up current Docile docs first.
Docile.remove(PACKAGE_NAME)

# Create a new docile setup.
Docile.init(PACKAGE_NAME)

@test isdir(DOC_DIR)
@test isfile(joinpath(DOC_DIR, "docile.jl"))

# Create documentation.
Docile.build(PACKAGE_NAME, [:output => [plain, html, helpdb]])

@test isdir(CACHE_DIR)
@test isdir(joinpath(CACHE_DIR, PACKAGE_NAME))

@test isfile(joinpath(CACHE_DIR, PACKAGE_NAME, "docs.md"))
@test isfile(joinpath(CACHE_DIR, PACKAGE_NAME, "docs.html"))
@test isfile(joinpath(CACHE_DIR, PACKAGE_NAME, "helpdb.jl"))

# Remove docile. The cache folder is *not* removed.
Docile.remove(PACKAGE_NAME)

@test !isfile(joinpath(CACHE_DIR, PACKAGE_NAME, "docs.md"))
@test !isfile(joinpath(CACHE_DIR, PACKAGE_NAME, "docs.html"))
@test !isfile(joinpath(CACHE_DIR, PACKAGE_NAME, "helpdb.jl"))

@test !isdir(joinpath(CACHE_DIR, PACKAGE_NAME))

# Rebuild the docs afterwards.
Docile.init(PACKAGE_NAME)
Docile.build(PACKAGE_NAME, [:output => [plain, html, helpdb]])
