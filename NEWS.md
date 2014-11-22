### v0.3.2

* Deprecate dict-based versions of `@doc` metadata and `@docstrings` macros.
* Automatic creation of documentation cache in modules when no `@docstrings` is provided.
* `@doc` support for `.` syntax used to extend methods from other modules.
* Julia `0.4` compatibility using the `Compat.jl` package.
* Use an `ObjectIdDict` for storing documentation cache. Allows for precompiling documented modules.

### v0.3.1

* Expand `Interface.parsedocs` documentation.
* Run Lint.jl on package to catch compatibility problems.

## v0.3.0

* Lazy caching of docstring ASTs.
* Add script to check for breakages in packages using Docile.
* Remove `@tex_str` macro.
* Remove vector version of `@docstrings`. Use `Dict` instead.
* Add NEWS.md file.
