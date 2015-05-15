module MetadataSyntax

"No meta-syntax."
no_meta_syntax = ()

"\!!setget(one_backslash_escape:One backslash is skipped and treated like a normal meta syntax.)"
one_backslash_escape = ()

"!! setget(space_between_backslash_metaname:Space between double ! and metaname is not a metasyntax.)"
space_between_backslash_metaname = ()

"!!setget (space_between_metaname_bracket:Space between metaname and bracket is not a metasyntax.)"
space_between_metaname_bracket = ()

"!!setget(license:[MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md))"
brackets_within_meta = ()

"!!setget(笔者:所以不多说了)"
chinese_unicode = ()

"\\!!setget(russian:бежал мета)"
backslash_escaped_meta = ()

"!!setget(meta_in_meta:Here we have an !!setget(inner:inner meta))"
meta_in_meta = ()

"!!setget(unicode_meta_in_meta:所以不多说了 !!setget(笔者_inner:бежал мета))"
unicode_meta_in_meta = ()

"""
!!setget(outer:Outer
!!setget(level1:Level1
!!setget(level2:Level2
!!setget(level3:Level3
!!setget(level4:Level4
!!setget(level5:Level5
!!setget(level6:Level6)))))))
"""
deep_nested_meta = ()

"\\!!setget(unicode_meta_in_meta:所以不多说了 !!setget(笔者_inner:бежал мета))"
backslash_escaped_nested_meta = ()

end
