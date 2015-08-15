# TODO: generalise this as a function in Lexicon.

using Docile, Lexicon

const source = "src"
const build  = "build"

const input  = [joinpath(source, f) for f in readdir(source)]
const output = [joinpath(build, f)  for f in readdir(source)]

for (i, o) in zip(input, output)
    info("Writing: ", i, " to ", o)
    Lexicon.Generate.loadfile(i, o)
end
