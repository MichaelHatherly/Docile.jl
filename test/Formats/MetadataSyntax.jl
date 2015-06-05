module MetadataSyntax

"No meta-syntax."
no_meta_syntax = ()

"\!!var(one_backslash_escape:One backslash is skipped and treated like a normal meta syntax.)"
one_backslash_escape = ()

"!! var(space_between_backslash_metaname:Space between double ! and metaname is not a metasyntax.)"
space_between_backslash_metaname = ()

"!!var (space_between_metaname_bracket:Space between metaname and bracket is not a metasyntax.)"
space_between_metaname_bracket = ()

"!!var(license:[MIT](https://github.com/MichaelHatherly/Lexicon.jl/blob/master/LICENSE.md))"
brackets_within_meta = ()

"!!var(笔者:所以不多说了)"
chinese_unicode = ()

"\\!!var(russian:бежал мета)"
backslash_escaped_meta = ()

"\\!!var(unicode_meta_in_meta:所以不多说了 !!var(笔者_inner:бежал мета))"
backslash_escaped_nested_meta = ()

end
