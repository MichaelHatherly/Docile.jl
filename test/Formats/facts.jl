require(joinpath(dirname(@__FILE__), "ExampleMeta1.jl"))

using ExampleMeta1

facts("ExampleMeta1.") do

    context("Check getparsed metadata replacement.") do

        expected_results = @compat(Dict(
            "example1: No meta-syntax." => "example1: No meta-syntax.",
            "example2: One section meta: !!section(Lexicon.md/Exported/Methods/1)" =>
                    "example2: One section meta: Lexicon.md/Exported/Methods/1",
            "example3: One escaped section meta: \\!!section(Lexicon.md/Exported/Methods/1)" =>
                    "example3: One escaped section meta: !!section(Lexicon.md/Exported/Methods/1)",
            "example4: One wrong half escaped section meta: \!!section(Lexicon.md/Exported/Methods/1)" =>
                    "example4: One wrong half escaped section meta: Lexicon.md/Exported/Methods/1",
#             "example5: unicode metaname: !!笔者(所以不多说了)" =>
#                     "example5: unicode metaname: 所以不多说了",
            "example6: space between double ! and metaname: !! spacy(Is that wrong)" =>
                    "example6: space between double ! and metaname: !! spacy(Is that wrong)",
            "example7: space between metaname and opening bracket: !!spacy (Is that wrong)" =>
                    "example7: space between metaname and opening bracket: !!spacy (Is that wrong)",
            "example8: meta within meta: !!multimeta(here is another meta: !!inner(This is the inner meta!))" =>
                    "example8: meta within meta: here is another meta: !!inner(This is the inner meta!)",
            "example9: meta within escaped meta: \\!!multimeta(here is another meta: !!inner(This is the inner meta!))" =>
                    "example9: meta within escaped meta: !!multimeta(here is another meta: This is the inner meta!)",
            "example10: usage of double ! within text: Ah I thought so!! That is why I like julia." =>
                    "example10: usage of double ! within text: Ah I thought so!! That is why I like julia.",
            "example11: reference to push method: use the push!(a, b,) method." =>
                    "example11: reference to push method: use the push!(a, b,) method.",
            "example12: brackets within meta: !!license([MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md))" =>
                    "example12: brackets within meta: [MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md)",
            "example13: `!!` is the prefix tag followed by a name and  open bracket ( and some text and closing bracket )." =>
                    "example13: `!!` is the prefix tag followed by a name and  open bracket ( and some text and closing bracket ).",
"""
example14: Mixed metadata - long example
!!site_name(Lexicon.jl)
!!site_description(Julia package documentation generator.)
!!repo_url(https://github.com/MichaelHatherly/Lexicon.jl)

!!site_author(Michael Hatherly)
!!copyright((c) Michael Hatherly and other contributors.)
!!license([MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md))


## Overview

*Lexicon* is a [Julia](http://www.julialang.org) package documentation generator
and viewer.

It provides access to the documentation created by the `@doc` macro from
[*Docile*][docile-url]. *Lexicon* allows querying of package documentation from
the Julia REPL and building standalone documentation that can be hosted on GitHub
Pages or [Read the Docs](https://readthedocs.org/).

You can use metadata in the documentation by including the `Docile metadata syntax` like this:

Example:

    \\!!section(Lexicon.md/Exported/Methods/1) this will be used to extract the final Section for the defined docstring.

`!!` is the prefix tag followed by a name and  open bracket ( and some text and closing bracket ).

!!args(
* `remove`: Bool if true the directory will be first removed.
* `modname`: Module name to add to the processed entries.
)

!!section(Lexicon.md/Exported/Methods/1)
""" =>
"""
example14: Mixed metadata - long example
Lexicon.jl
Julia package documentation generator.
https://github.com/MichaelHatherly/Lexicon.jl

Michael Hatherly
(c) Michael Hatherly and other contributors.
[MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md)


## Overview

*Lexicon* is a [Julia](http://www.julialang.org) package documentation generator
and viewer.

It provides access to the documentation created by the `@doc` macro from
[*Docile*][docile-url]. *Lexicon* allows querying of package documentation from
the Julia REPL and building standalone documentation that can be hosted on GitHub
Pages or [Read the Docs](https://readthedocs.org/).

You can use metadata in the documentation by including the `Docile metadata syntax` like this:

Example:

    !!section(Lexicon.md/Exported/Methods/1) this will be used to extract the final Section for the defined docstring.

`!!` is the prefix tag followed by a name and  open bracket ( and some text and closing bracket ).

* `remove`: Bool if true the directory will be first removed.
* `modname`: Module name to add to the processed entries.

Lexicon.md/Exported/Methods/1
"""
            ))


        for (obj, txt) in Docile.Cache.getraw(ExampleMeta1)
            @fact Docile.Cache.getparsed(ExampleMeta1, obj) => expected_results[txt]
       end
    end

end
