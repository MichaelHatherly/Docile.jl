module MacroSpec

using Docile
@docstrings

TESTCASE = readall(joinpath(Pkg.dir("Docile"), "test", "tests", "test-case.md"))

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing methods")

@doc """
$(TESTCASE)
""" [
    :key => :value
    ] ->
function docs_and_meta(x)
end

@doc """
$(TESTCASE)
""" ->
function docs_no_meta(x)
end

@doc [ :file => "test-case.md", :key => :value ] ->
function extern_docs_meta(x)
end

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing single line methods")

@doc """
$(TESTCASE)
""" [
    :key => :value
    ] ->
inline_docs_meta(x) = x

@doc """
$(TESTCASE)
""" ->
inline_docs_no_meta(x) = x

@doc [ :file => "test-case.md", :key => :value ] ->
inline_extern_docs_meta(x) = x

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing generic functions")

@doc """
$(TESTCASE)
""" [
    :key => :value
    ] ->
inline_docs_meta

@doc """
$(TESTCASE)
""" ->
inline_docs_no_meta

@doc [ :file => "test-case.md", :key => :value ] ->
inline_extern_docs_meta

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing types")

@doc """
$(TESTCASE)
""" [
    :key => :value
    ] ->
type DocsAndMeta
end

@doc """
$(TESTCASE)
""" ->
type DocsNoMeta
end

@doc [ :file => "test-case.md", :key => :value ] ->
type ExternDocsMeta
end

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing immutable types")

@doc """
$(TESTCASE)
""" [
    :key => :value
    ] ->
immutable DocsAndMetaImm
end

@doc """
$(TESTCASE)
""" ->
immutable DocsNoMetaImm
end

@doc [ :file => "test-case.md", :key => :value ] ->
immutable ExternDocsMetaImm
end

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing abstract types")

@doc """
$(TESTCASE)
""" [
    :key => :value
    ] ->
abstract DocsAndMetaAbs

@doc """
$(TESTCASE)
""" ->
abstract DocsNoMetaAbs

@doc [ :file => "test-case.md", :key => :value ] ->
abstract ExternDocsMetaAbs

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing constants")

@doc """
$(TESTCASE)
""" [
    :key => :value
    ] ->
const DocsAndMetaConst = 1

@doc """
$(TESTCASE)
""" ->
const DocsNoMetaConst = 1

@doc [ :file => "test-case.md", :key => :value ] ->
const ExternDocsMetaConst = 1

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing globals")

@doc """
$(TESTCASE)
""" [
    :key => :value
    ] ->
DocsAndMetaGlobal = 1

@doc """
$(TESTCASE)
""" ->
DocsNoMetaGlobal = 1

@doc [ :file => "test-case.md", :key => :value ] ->
ExternDocsMetaGlobal = 1

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing macros")

@doc """
$(TESTCASE)
""" [
    :key => :value
    ] ->
macro docs_and_meta(x)
end

@doc """
$(TESTCASE)
""" ->
macro docs_no_meta(x)
end

@doc [ :file => "test-case.md", :key => :value ] ->
macro extern_docs_meta(x)
end

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing modules")

@doc """
$(TESTCASE)
""" [
    :key => :value
    ] ->
MacroSpec

@doc """
$(TESTCASE)
""" ->
MacroSpec

@doc [ :file => "test-case.md", :key => :value ] ->
MacroSpec

end

@test modulename(documentation(MacroSpec)) === MacroSpec
