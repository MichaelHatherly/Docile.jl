# Complete spec detailing how `@doc` *should* work.
module MacroSpecTests

using Base.Test

import Markdown

## test case text –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

TESTCASE = readall(joinpath(Pkg.dir("Docile"), "test", "test-case.md"))
TESTCASE_PARSED = Markdown.parse(TESTCASE)

# TODO: maybe add more cases

## test driver ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

symname(s::Symbol)   = s
symname(s::Method)   = s.func.code.name
symname(s::DataType) = s.name.name
symname(s::Function) = symname(s.env.defs)
symname(s::Module)   = symbol("$s")

function tester(ents, typ, case; verbose = false)

    if verbose
        xdump(ents)
        @show ents typ case
        @show typeof(ents[1])
    end

    obj, ent = ents.entries[1]

    @test isa(obj, typ)
    @test isdefined(symname(obj))

    @test !isempty(ent.docs.content)
    @test isa(ent.docs.content[1], Markdown.Header{1})
    @test isa(ent.docs.content[end], Markdown.BlockCode)

    if case == :docsmeta
        @test haskey(ent.meta, :key)
        @test length(ent.meta) == 2
    elseif case == :docs
        @test !haskey(ent.meta, :key)
        @test length(ent.meta) == 1
    elseif case == :meta
        @test haskey(ent.meta, :key)
        @test haskey(ent.meta, :file)
        @test ent.meta[:file] == "test-case.md"
        @test length(ent.meta) == 3
    else
        error("undefined case in `tester`")
    end
end

## state init –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

using Docile
@docstrings

OBJECT_COUNT = 0

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing __METADATA__ object")

@test isdefined(:__METADATA__)

@test isa(__METADATA__, Docile.Documentation)
@test isa(__METADATA__.entries, Dict{Any,Docile.Entry})
@test isa(__METADATA__.modname, Module)

@test isempty(__METADATA__.entries)
@test __METADATA__.modname == current_module()

@test length(__METADATA__.entries) == OBJECT_COUNT

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing methods")

@doc """
$(TESTCASE)
""" {
    :key => :value
    } ->
function docs_and_meta(x)
end
@query docs_and_meta(1)
tester((@query docs_and_meta(1);), Method, :docsmeta)

@doc """
$(TESTCASE)
""" ->
function docs_no_meta(x)
end
tester((@query docs_no_meta(1);), Method, :docs)

@doc { :file => "test-case.md", :key => :value } ->
function extern_docs_meta(x)
end
tester((@query extern_docs_meta(1);), Method, :meta)

OBJECT_COUNT += 3
@test length(__METADATA__.entries) == OBJECT_COUNT

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing single line methods")

@doc """
$(TESTCASE)
""" {
    :key => :value
    } ->
inline_docs_meta(x) = x
tester((@query inline_docs_meta(1);), Method, :docsmeta)

@doc """
$(TESTCASE)
""" ->
inline_docs_no_meta(x) = x
tester((@query inline_docs_no_meta(1);), Method, :docs)

@doc { :file => "test-case.md", :key => :value } ->
inline_extern_docs_meta(x) = x
tester((@query inline_extern_docs_meta(1);), Method, :meta)

OBJECT_COUNT += 3
@test length(__METADATA__.entries) == OBJECT_COUNT

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing generic functions")

@doc """
$(TESTCASE)
""" {
    :key => :value
    } ->
inline_docs_meta
tester(query(inline_docs_meta; all = false), Function, :docsmeta)

@doc """
$(TESTCASE)
""" ->
inline_docs_no_meta
tester(query(inline_docs_no_meta; all = false), Function, :docs)

@doc { :file => "test-case.md", :key => :value } ->
inline_extern_docs_meta
tester(query(inline_extern_docs_meta; all = false), Function, :meta)

OBJECT_COUNT += 3
@test length(__METADATA__.entries) == OBJECT_COUNT

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing types")

@doc """
$(TESTCASE)
""" {
    :key => :value
    } ->
type DocsAndMeta
end
tester(query(DocsAndMeta), DataType, :docsmeta)

@doc """
$(TESTCASE)
""" ->
type DocsNoMeta
end
tester(query(DocsNoMeta), DataType, :docs)

@doc { :file => "test-case.md", :key => :value } ->
type ExternDocsMeta
end
tester(query(ExternDocsMeta), DataType, :meta)

OBJECT_COUNT += 3
@test length(__METADATA__.entries) == OBJECT_COUNT

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing immutable types")

@doc """
$(TESTCASE)
""" {
    :key => :value
    } ->
immutable DocsAndMetaImm
end
tester(query(DocsAndMetaImm), DataType, :docsmeta)

@doc """
$(TESTCASE)
""" ->
immutable DocsNoMetaImm
end
tester(query(DocsNoMetaImm), DataType, :docs)

@doc { :file => "test-case.md", :key => :value } ->
immutable ExternDocsMetaImm
end
tester(query(ExternDocsMetaImm), DataType, :meta)

OBJECT_COUNT += 3
@test length(__METADATA__.entries) == OBJECT_COUNT

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing abstract types")

@doc """
$(TESTCASE)
""" {
    :key => :value
    } ->
abstract DocsAndMetaAbs
tester(query(DocsAndMetaAbs), DataType, :docsmeta)

@doc """
$(TESTCASE)
""" ->
abstract DocsNoMetaAbs
tester(query(DocsNoMetaAbs), DataType, :docs)

@doc { :file => "test-case.md", :key => :value } ->
abstract ExternDocsMetaAbs
tester(query(ExternDocsMetaAbs), DataType, :meta)

OBJECT_COUNT += 3
@test length(__METADATA__.entries) == OBJECT_COUNT

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing constants")

@doc """
$(TESTCASE)
""" {
    :key => :value
    } ->
const DocsAndMetaConst = 1
tester((@query global DocsAndMetaConst;), Symbol, :docsmeta)

@doc """
$(TESTCASE)
""" ->
const DocsNoMetaConst = 1
tester((@query global DocsNoMetaConst;), Symbol, :docs)

@doc { :file => "test-case.md", :key => :value } ->
const ExternDocsMetaConst = 1
tester((@query global ExternDocsMetaConst;),Symbol, :meta)

OBJECT_COUNT += 3
@test length(__METADATA__.entries) == OBJECT_COUNT

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing globals")

@doc """
$(TESTCASE)
""" {
    :key => :value
    } ->
DocsAndMetaGlobal = 1
tester((@query global DocsAndMetaGlobal;), Symbol, :docsmeta)

@doc """
$(TESTCASE)
""" ->
DocsNoMetaGlobal = 1
tester((@query global DocsNoMetaGlobal;), Symbol, :docs)

@doc { :file => "test-case.md", :key => :value } ->
ExternDocsMetaGlobal = 1
tester((@query global ExternDocsMetaGlobal;), Symbol, :meta)

OBJECT_COUNT += 3
@test length(__METADATA__.entries) == OBJECT_COUNT

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing macros")

@doc """
$(TESTCASE)
""" {
    :key => :value
    } ->
macro docs_and_meta(x)
end
tester((@query @docs_and_meta;), Symbol, :docsmeta)

@doc """
$(TESTCASE)
""" ->
macro docs_no_meta(x)
end
tester((@query @docs_no_meta;), Symbol, :docs)

@doc { :file => "test-case.md", :key => :value } ->
macro extern_docs_meta(x)
end
tester((@query @extern_docs_meta;), Symbol, :meta)

OBJECT_COUNT += 3
@test length(__METADATA__.entries) == OBJECT_COUNT

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing modules")

@doc """
$(TESTCASE)
""" {
    :key => :value
    } ->
MacroSpecTests
tester(query(MacroSpecTests), Module, :docsmeta)

@doc """
$(TESTCASE)
""" ->
MacroSpecTests
tester(query(MacroSpecTests), Module, :docs)

@doc { :file => "test-case.md", :key => :value } ->
MacroSpecTests
tester(query(MacroSpecTests), Module, :meta)

OBJECT_COUNT += 1
@test length(__METADATA__.entries) == OBJECT_COUNT

## ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
info("testing doctest")

doctest(MacroSpecTests)

end
