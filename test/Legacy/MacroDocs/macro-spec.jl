module MacroSpec

import Docile: @doc, meta

TESTCASE = "testcase"

## Testing methods. ##

@doc meta("docs_and_meta/1", key = :docs_and_meta) ->
function docs_and_meta(x)
end

@doc "docs_no_meta/1" ->
function docs_no_meta(x)
end

@doc meta(file = "test_case.md", key = :test_case) ->
function extern_docs_meta(x)
end

## Testing single line methods. ##

@doc meta("inline_docs_meta/1", key = :inline_docs_meta) ->
inline_docs_meta(x) = x

@doc "inline_docs_no_meta/1" ->
inline_docs_no_meta(x) = x

@doc meta(file = "test_case.md", key = :test_case) ->
inline_extern_docs_meta(x) = x

## Testing generic functions. ##

@doc meta("inline_docs_meta", key = :inline_docs_meta) ->
inline_docs_meta

@doc "inline_docs_no_meta" ->
inline_docs_no_meta

@doc meta(file = "test_case.md", key = :test_case) ->
inline_extern_docs_meta

## Testing types. ##

@doc meta("DocsAndMeta", key = :DocsAndMeta) ->
type DocsAndMeta
end

@doc "DocsNoMeta" ->
type DocsNoMeta
end

@doc meta(file = "test_case.md", key = :test_case) ->
type ExternDocsMeta
end

## Testing immutable types. ##

@doc meta("DocsAndMetaImm", key = :DocsAndMetaImm) ->
immutable DocsAndMetaImm
end

@doc "DocsNoMetaImm" ->
immutable DocsNoMetaImm
end

@doc meta(file = "test_case.md", key = :test_case) ->
immutable ExternDocsMetaImm
end

## Testing abstract types. ##

@doc meta("DocsAndMetaAbs", key = :DocsAndMetaAbs) ->
abstract DocsAndMetaAbs

@doc "DocsNoMetaAbs" ->
abstract DocsNoMetaAbs

@doc meta(file = "test_case.md", key = :test_case) ->
abstract ExternDocsMetaAbs

## Testing constants. ##

@doc meta("DocsAndMetaConst", key = :DocsAndMetaConst) ->
const DocsAndMetaConst = 1

@doc "DocsNoMetaConst" ->
const DocsNoMetaConst = 1

@doc meta(file = "test_case.md", key = :test_case) ->
const ExternDocsMetaConst = 1

## Testing globals. ##

@doc meta("DocsAndMetaGlobal", key = :DocsAndMetaGlobal) ->
DocsAndMetaGlobal = 1

@doc "DocsNoMetaGlobal" ->
DocsNoMetaGlobal = 1

@doc meta(file = "test_case.md", key = :test_case) ->
ExternDocsMetaGlobal = 1

## Testing macros. ##

@doc meta("macro_docs_and_meta", key = :macro_docs_and_meta) ->
macro docs_and_meta(x)
end

@doc "macro_docs_no_meta" ->
macro docs_no_meta(x)
end

@doc meta(file = "test_case.md", key = :test_case) ->
macro extern_docs_meta(x)
end

## Testing modules. ##

@doc meta("MacroSpec_meta", key = :MacroSpec_meta) ->
MacroSpec

@doc "MacroSpec_no_meta" ->
MacroSpec

@doc meta(file = "test_case.md", key = :test_case) ->
MacroSpec

end
