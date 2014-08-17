module Docile

import AnsiColor, Markdown

import Base: triplequoted, writemime, push!
import Base.Meta: isexpr

export query, doctest, @query, @doc, @docstrings, @tex_mstr

include("types.jl")
include("docstrings.jl")

# Initialise docstrings for this module. Can't document previous files
# since they define the docstring methods/macros.
@docstrings

include("render.jl")
include("doctest.jl")
include("query.jl")

# link the readme into the package docs
@doc [ :file => "../README.md" ] .. Docile

# Inject docs after the fact since we can't run @doc on itself. **Internal use only.**
__METADATA__.docs[symbol("@doc")] =
    Entry{:macro}("""

    Document objects in source code, namely:

    * functions
    * methods
    * macros
    * types
    * globals
    * modules

    Takes a multiline string as documentation and/or a `(Symbol => Any)`
    dictionary containing metadata. Only one needs to be provided, but
    the docstring **must** appear first if both are needed.

    **Example:**
    ```julia
    @doc \"\"\"
    Markdown formatted text appears here...
    \"\"\" [
        :key => :value
        ] ..
    f(x) = x
    ```
    """, [ :section => "Documentation Macros" ])

__METADATA__.docs[symbol("@docstrings")] =
    Entry{:macro}("""

    Module documentation initialiser. Run this macro prior to any `@doc`
    uses in a module.

    Creates the required `Documentation` object used to store a module's
    docstrings.

    **Example:**
    ```julia
    using Docile
    @docstrings

    # `@doc` uses appear after this.
    ```
    """, [ :section => "Documentation Macros" ])

__METADATA__.docs[Entry] =
    Entry{:type}("""

    Type representing an docstring and associated metadata in the
    module's `Documentation` object.

    """, [:section => "Internals",
          :fields => [
              (:docs, "markdown AST representing the docstring"),
              (:meta, "key/value pairs of arbitary data related to object being documented")
              ]
          ])

__METADATA__.docs[Documentation] =
    Entry{:type}("""

    Stores the documentation generated for a module via `@doc`. The
    instance created in a module via `@docstrings` is called
    `__METADATA__`.

    """, [:section => "Internals",
          :fields => [
              (:modname, "name of the module in which the Documentation is located"),
              (:docs, "dictionary containing the objects being documented and their related docstring/metadata")
              ]
          ])

end # module
