### v0.5.22

* Fix test errors on `0.5-dev` with `mostgeneral` and `name` methods.

### v0.5.21

* Fix issues caused by `julia/jb/functions` branch changes.

### v0.5.20

* Fix Lexicon issue [#134](https://github.com/MichaelHatherly/Lexicon.jl/issues/134).

### v0.5.19

* Fix deprecation warnings.

### v0.5.18

* Fix for changes to ``LineNumberNode``.

### v0.5.17

* Fix for changes to ``FactCheck.jl``.
* Move from Coveralls to Codecov for coverage.
* Add OSX Travis testing.

### v0.5.16

* Add support for documenting multiple functions with a single docstring using tuple syntax:

  ```julia
  "..."
  f, f!
  ```

  The current vector syntax:

  ```julia
  "..."
  [f, f!]
  ```

  will continue to work in 0.3, but will raise an error in 0.4's docsystem.

### v0.5.15

* Fix deprecation warnings.

### v0.5.14

* Fix external documentation checking.

### v0.5.13

* Fix module loading error.

### v0.5.12

* Manually initialise cache rather than by using ``__init__``.

### v0.5.11

* Fix for pre-compilation error.

### v0.5.10

* Fixes for Julia 0.4 bare docstring syntax.

### v0.5.9

* Fix for removal of ``@mstr`` from ``Base``.

### v0.5.8

* Fix implicit "external file as docstring" validation code.

### v0.5.7

* Add support for ``bitstype`` documentation.

### v0.5.6

* Implement automatic caching of parsed expressions. Improves loading time of help.
* Turn on caching of ``Base`` by default.

### v0.5.5

* Fix parsing bug for files with no newline at end of file.
* Reduce REPL output from caching.
* Rename ``!!setget`` to ``!!var``.

### v0.5.4

* Add ``MarkdownFormatter``.

### v0.5.3

* Fix method finding bug for multiline signatures.

### v0.5.2

* Fix escaping bug.
* Re-add deprecated ``@md_str`` and ``@md_mstr`` and warn on usage.

### v0.5.1

* Fix ``@doc`` bug for qualified methods.

## v0.5.0

* Move to autoextracted docstrings. ``@doc`` and ``@document`` remain as before.
* Rename and split ``__METADATA__`` as ``__DOCILE_STRINGS__`` and ``__DOCILE_METADATA__``.
* Stable modules are ``Docile`` and ``Docile.Interface``. Other modules are subject to change.

### v0.4.13

* Rename files to account for case-insensitive filesystems.

### v0.4.12

* Fix methods in wrong modules being documented.

### v0.4.11

* Fix for changes in import behaviour.

### v0.4.10

* Fix for `TypeVar` equality in method lookup.

### v0.4.9

* Fix for tuple changes in julia.

### v0.4.8

* Deprecate `@doc*` in favour of `@doc+` due to parser error for unary `*`.

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
