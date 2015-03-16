### v0.4.7

* Use `fieldnames` instead of deprecated `names`.

### v0.4.6

* Fix wrongly quoted `:end` syntax affecting older 0.3 release.

### v0.4.5

* Add missing `Interface.name(::Module)` method.
* Fix unclear error message when using `@document` from the REPL.

### v0.4.4

* Handle new expression head `:triple_quoted_string`.
* Fix deprecation warning for array syntax.

### v0.4.3

* Fix incorrect outer constructor signature matching.

### v0.4.2

* Fix vcat/vect parsing changes.

### v0.4.1

* Fix deprecation warnings.

## v0.4.0

* New plain string docstrings.
* New documentation site using MkDocs.
* Store macros using their corresponding anonymous functions as keys.
* Add missing `@doc_str` macro.

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
