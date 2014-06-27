# Docile Documentation

**`Docile.Docile`**

A package documentation package for Julia.

Docile can extract multiline strings from julia source files and
associated metadata to create several different human readable
documentation formats.

**`Docile.@doc_mstr(text)`**

Allow use of `$` and `\` in doc strings to support LaTeX equations.

**`Docile.Doc{category}`**

Documentation and metadata extracted from doc strings.

**`Docile.plain(package::String,docs::Vector{Doc})`**

Save `docs` as a markdown-formatted `docs.md` file in `package` cache.

**`Docile.helpdb(package::String,docs::Vector{Doc})`**

Save `docs` in the `package`-specific cache directory in a format
compatible with the standard julia helpdb file.

**`Docile.html(package::String,docs::Vector{Doc})`**

Save `docs` as a self-contained html page in `package` cache.

**`Docile.build(package::String,config::Dict)`**

Extract doc strings from all source files in `package`. Generate
formatted documentation using the settings specified in `config`.

**`Docile.init(package::String)`**

Setup Docile for specified `package`. Creates a `docs/` folder if
needed, as well as a default config file that can be used to run Docile
for the `package`.

**`Docile.remove(package::String)`**

Remove Docile from `package`. The cache folder for the `package` and the
config file are deleted.

**`Docile.patch!()`**

Modify functions `Base.Help.init_help` and `Base.Help.help` to allow
loading of external help files along with the standard `helpdb.jl` file.

