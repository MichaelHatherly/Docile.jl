# Try to load packages that rely on Docile so then don't get broken.

const PACKAGES = [
    "Diversity",
    "HttpServer"
    ]

for package in PACKAGES
    file = joinpath(Pkg.dir(package), "src", package * ".jl")
    try
        info("Trying $(package)...")
        include(file)
    catch err
        warn("Failed $(package).")
        println(err)
    end
end
