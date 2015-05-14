const packages = [
    "AverageShiftedHistograms",
    "BDF",
    "BrainWave",
    "Diversity",
    "IterativeSolvers",
    "RCall",
    "SDT",
    "Sims",
    "TargetedLearning"
    ]

const failures = Set()

for package in packages
    print(" - ", package)
    try
        require(package)
        println(" ✓")
    catch err
        push!(failures, (package, err))
        println(" ×")
    end
end

println("-"^50)

for (package, err) in failures
    println("""

    # $(package)

    $(err)

    ---
    """)
end

failures
