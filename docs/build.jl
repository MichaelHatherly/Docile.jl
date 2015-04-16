using Docile, Lexicon

const api_directory = "api"
const modules = [Docile, Docile.Interface]

cd(dirname(@__FILE__)) do

    # Run the doctests *before* we start to generate *any* documentation.
    for m in modules
        failures = failed(doctest(m))
        if !isempty(failures.results)
            println("\nDoctests failed, aborting commit.\n")
            display(failures)
            exit(1) # Bail when doctests fail.
        end
    end

    # Generate and save the contents of docstrings as markdown files.
    config = nothing
    for m in modules
        filename = joinpath(api_directory, "$(module_name(m)).md")
        try
           config = save(filename, m; md_genindex=true, md_permalink=true, md_groupby_category=true)
            # Save individual API-Index
            #savegenindex(joinpath(api_directory, "$(module_name(m))_genindex.md"), config)
        catch err
            println(err)
            exit(1)
        end
    end
    # Save all API-Index: this does not work togehter with individual: just one of them can be used because
    # calling `savegenindex` will on purpose clear the collected data
    savegenindex(joinpath(api_directory, "genindex.md"), config)


    # Add a reminder not to edit the generated files.
    open(joinpath(api_directory, "README.md"), "w") do f
        print(f, """
        Files in this directory are generated using the `build.jl` script. Make
        all changes to the originating docstrings/files rather than these ones.

        Documentation should *only* be build directly on the `master` branch.
        Source links would otherwise become unavailable should a branch be
        deleted from the `origin`. This means potential pull request authors
        *should not* run the build script when filing a PR.
        """)
    end

    info("Adding all documentation changes in $(api_directory) to this commit.")
    success(`git add $(api_directory)`) || exit(1)

end
