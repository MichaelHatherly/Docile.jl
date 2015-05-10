module ExampleMeta1

"example1: No meta-syntax."
function example1() end

"example2: One section meta: !!section(Lexicon.md/Exported/Methods/1)"
function example2() end

"example3: One escaped section meta: \\!!section(Lexicon.md/Exported/Methods/1)"
function example3() end

"example4: One wrong half escaped section meta: \!!section(Lexicon.md/Exported/Methods/1)"
function example4() end

"example5: unicode metaname: !!笔者(所以不多说了)"
function example5() end

"example6: space between double ! and metaname: !! spacy(Is that wrong)"
function example6() end

"example7: space between metaname and opening bracket: !!spacy (Is that wrong)"
function example7() end

"example8: meta within meta: !!multimeta(here is another meta: !!inner(This is the inner meta!))"
function example8() end

"example9: meta within escaped meta: \\!!multimeta(here is another meta: !!inner(This is the inner meta!))"
function example9() end

"example10: usage of double ! within text: Ah I thought so!! That is why I like julia."
function example10() end

"example11: reference to push method: use the push!(a, b,) method."
function example11() end

"example12: brackets within meta: !!license([MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md))"
function example12() end

"example13: `!!` is the prefix tag followed by a name and  open bracket ( and some text and closing bracket )."
function example13() end

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
"""
function example14() end





end
