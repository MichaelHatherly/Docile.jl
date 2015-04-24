module MacroSpec

using Docile

TESTCASE = readall(joinpath(Pkg.dir("Docile"), "test", "macro", "subfiles", "test-case.md"))

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing methods")

Docile.@doc meta("""
$(TESTCASE)
""", key = :value) ->
function docs_and_meta(x)
end

Docile.@doc """
$(TESTCASE)
""" ->
function docs_no_meta(x)
end

Docile.@doc meta(file = "test-case.md", key = :value) ->
function extern_docs_meta(x)
end

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing single line methods")

Docile.@doc meta("""
$(TESTCASE)
""", key = :value) ->
inline_docs_meta(x) = x

Docile.@doc """
$(TESTCASE)
""" ->
inline_docs_no_meta(x) = x

Docile.@doc meta(file = "test-case.md", key = :value) ->
inline_extern_docs_meta(x) = x

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing generic functions")

Docile.@doc meta("""
$(TESTCASE)
""", key = :value) ->
inline_docs_meta

Docile.@doc """
$(TESTCASE)
""" ->
inline_docs_no_meta

Docile.@doc meta(file = "test-case.md", key = :value) ->
inline_extern_docs_meta

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing types")

Docile.@doc meta("""
$(TESTCASE)
""", key = :value) ->
type DocsAndMeta
end

Docile.@doc """
$(TESTCASE)
""" ->
type DocsNoMeta
end

Docile.@doc meta(file = "test-case.md", key = :value) ->
type ExternDocsMeta
end

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing immutable types")

Docile.@doc meta("""
$(TESTCASE)
""", key = :value) ->
immutable DocsAndMetaImm
end

Docile.@doc """
$(TESTCASE)
""" ->
immutable DocsNoMetaImm
end

Docile.@doc meta(file = "test-case.md", key = :value) ->
immutable ExternDocsMetaImm
end

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing abstract types")

Docile.@doc meta("""
$(TESTCASE)
""", key = :value) ->
abstract DocsAndMetaAbs

Docile.@doc """
$(TESTCASE)
""" ->
abstract DocsNoMetaAbs

Docile.@doc meta(file = "test-case.md", key = :value) ->
abstract ExternDocsMetaAbs

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing constants")

Docile.@doc meta("""
$(TESTCASE)
""", key = :value) ->
const DocsAndMetaConst = 1

Docile.@doc """
$(TESTCASE)
""" ->
const DocsNoMetaConst = 1

Docile.@doc meta(file = "test-case.md", key = :value) ->
const ExternDocsMetaConst = 1

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing globals")

Docile.@doc meta("""
$(TESTCASE)
""", key = :value) ->
DocsAndMetaGlobal = 1

Docile.@doc """
$(TESTCASE)
""" ->
DocsNoMetaGlobal = 1

Docile.@doc meta(file = "test-case.md", key = :value) ->
ExternDocsMetaGlobal = 1

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing macros")

Docile.@doc meta("""
$(TESTCASE)
""", key = :value) ->
macro docs_and_meta(x)
end

Docile.@doc """
$(TESTCASE)
""" ->
macro docs_no_meta(x)
end

Docile.@doc meta(file = "test-case.md", key = :value) ->
macro extern_docs_meta(x)
end

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing modules")

Docile.@doc meta("""
$(TESTCASE)
""", key = :value) ->
MacroSpec

Docile.@doc """
$(TESTCASE)
""" ->
MacroSpec

Docile.@doc meta(file = "test-case.md", key = :value) ->
MacroSpec

end
