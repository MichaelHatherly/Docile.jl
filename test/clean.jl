# Clean out coverage files.

cd(joinpath(dirname(@__FILE__), "..")) do
    for dir in ["src", "test"]
        cd(dir) do
            for file in readdir()
                endswith(file, ".cov") && rm(file)
            end
        end
    end
end
