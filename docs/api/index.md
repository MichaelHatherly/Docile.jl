# API-INDEX


## MODULE: Docile.Extensions

---

## Modules [Exported]

[Docile.Extensions](Docile.Extensions.md#module__extensions.1)  Methods to extend how Docile handles parsing of docstrings.

---

## Methods [Internal]

[metamacro(::Docile.Formats.MetaMacro{:get}, body, mod, obj)](Docile.Extensions.md#method__metamacro.1)  Get the value stored in an object's metadata field.

[metamacro(::Docile.Formats.MetaMacro{:include}, body, mod, obj)](Docile.Extensions.md#method__metamacro.2)  Splice the contents of a file in place of the ``metamacro`` call.

[metamacro(::Docile.Formats.MetaMacro{:longform}, body, mod, obj)](Docile.Extensions.md#method__metamacro.3)  Make the contained text only appear in non-interactive output.

[metamacro(::Docile.Formats.MetaMacro{:setget}, body, mod, obj)](Docile.Extensions.md#method__metamacro.4)  Equivalent to ``!!set`` followed by ``!!get`` for the provided key.

[metamacro(::Docile.Formats.MetaMacro{:set}, body, mod, obj)](Docile.Extensions.md#method__metamacro.5)  Set the value for a field in an object's metadata.

[metamacro(::Docile.Formats.MetaMacro{:summary}, body, mod, obj)](Docile.Extensions.md#method__metamacro.6)  Specify a short (120 character) summary for a docstring.

## MODULE: Docile.Cache

---

## Methods [Exported]

[clear!()](Docile.Cache.md#method__clear.1)  Remove all cached objects, modules and packages from storage.

[getmeta(m::Module)](Docile.Cache.md#method__getmeta.1)  Return a reference to the metadata cache for a given module `m`.

[getmeta(m::Module, obj)](Docile.Cache.md#method__getmeta.2)  Return the metadata `Dict` for a given object `obj` found in module `m`.

[getparsed(m::Module)](Docile.Cache.md#method__getparsed.1)  Return a reference to the parsed docstring cache for a given module `m`.

[getparsed(m::Module, obj)](Docile.Cache.md#method__getparsed.2)  Return the parsed form of a docstring for object `obj` in module `m`.

[getraw(m::Module)](Docile.Cache.md#method__getraw.1)  Return a reference to the raw docstring storage for a given module `m`.

[getraw(m::Module, obj)](Docile.Cache.md#method__getraw.2)  Return the raw docstring for a given `obj` in the module `m`.

[objects(m::Module)](Docile.Cache.md#method__objects.1)  List of all documented objects in a module `m`.

---

## Methods [Internal]

[cleardocs!()](Docile.Cache.md#method__cleardocs.1)  Empty cached docstrings, parsed docs, and metadata from all modules.

[clearpackages!()](Docile.Cache.md#method__clearpackages.1)  Empty all loaded packages and modules from cache.

[extractor!(raw::AbstractString, m::Module, obj)](Docile.Cache.md#method__extractor.1)  Extract metadata embedded in docstrings and run the `parsedocs` method defined

[getdocs(m::Module)](Docile.Cache.md#method__getdocs.1)  Return documentation cache of a module `m`. Initialise an empty cache if needed.

[getmodule(m::Module)](Docile.Cache.md#method__getmodule.1)  Get the `ModuleData` object associated with a module `m`.

[getpackage(m::Module)](Docile.Cache.md#method__getpackage.1)  Return the `PackageData` object that represents a registered package.

[hasdocs(m::Module)](Docile.Cache.md#method__hasdocs.1)  Has module `m` had documentation extracted with `Docile.Collector.docstrings`?

[hasmodule(m::Module)](Docile.Cache.md#method__hasmodule.1)  Has the module `m` been registered with Docile.

[haspackage(m::Module)](Docile.Cache.md#method__haspackage.1)  Has the package with root module `m` been registered with Docile?

[hasparsed(m::Module)](Docile.Cache.md#method__hasparsed.1)  Has module `m` been parsed yet?

[modules()](Docile.Cache.md#method__modules.1)  List of all documented modules currently stored by Docile.

[parse!(m::Module)](Docile.Cache.md#method__parse.1)  Parse raw docstrings in module `m` into their parsed form.

[setparsed(m::Module)](Docile.Cache.md#method__setparsed.1)  Module `m` has had it's docstrings parsed.

[togglebase()](Docile.Cache.md#method__togglebase.1)  Switch on/off documenting of ``Base`` and it's submodules.

---

## Macros [Internal]

[@+expr](Docile.Cache.md#macro____.1)  Macro to make a function definition global. Used in `let`-blocks.

## MODULE: Docile.Collector

---

## Functions [Internal]

[isdocstring](Docile.Collector.md#function__isdocstring.1)  Does the expression represent a docstring?

[name](Docile.Collector.md#function__name.1)  Extract the symbol identifying an expression.

[process!](Docile.Collector.md#function__process.1)  Extract all docstrings and metadata from a given file

[recheck](Docile.Collector.md#function__recheck.1)  Convert category from `:symbol` to either `:module` or `:function`.

---

## Methods [Internal]

[definedmodules!(out, expr::Expr)](Docile.Collector.md#method__definedmodules.1)  Return the set of toplevel modules that are defined in an expression.

[findexternal(docs)](Docile.Collector.md#method__findexternal.1)  Check whether a docstring is acutally a file path. Read that instead if it is.

[findmodule(expr::Expr, mod::Module)](Docile.Collector.md#method__findmodule.1)  Extract the module expression corresponding to a `Module` object.

[findpackages(rootfiles::Set{UTF8String})](Docile.Collector.md#method__findpackages.1)  Return the `PackageData` objects associated with a set of files.

[get_aside!(output, moddata, state, file, block)](Docile.Collector.md#method__get_aside.1)  Extract the comment block from expressions and capture metadata.

[get_docs!(output, moduledata, state, file, block)](Docile.Collector.md#method__get_docs.1)  Extract a docstring and associated object(s) as well as metadata.

[getcategory(x)](Docile.Collector.md#method__getcategory.1)  The category of an expression. `:symbol` is resolved at a later stage by `recheck`.

[getdotfile(dir::AbstractString)](Docile.Collector.md#method__getdotfile.1)  Check for a `.docile` configuration file in the directory `dir`.

[getobject(::Docile.Utilities.Head{:macro}, moduledata, state, expr, ::Any)](Docile.Collector.md#method__getobject.1)  Get the `(anonymous function)` object defined by a macro expression.

[getobject(::Docile.Utilities.Head{:method}, moduledata, state, expr, codesource)](Docile.Collector.md#method__getobject.2)  Find all `Method` objects defined by a given expression.

[getobject(::Docile.Utilities.Head{:tuple}, ::Any, state, expr, ::Any)](Docile.Collector.md#method__getobject.3)  Find group of methods that match a provided signature.

[getobject(::Union(Docile.Utilities.Head{:vect}, Docile.Utilities.Head{:vcat}), ::Any, state, expr, ::Any)](Docile.Collector.md#method__getobject.4)  Find a set of methods and a set of functions that match the provided vector.

[getobject(cat::Symbol, moduledata, state, expr, codesource)](Docile.Collector.md#method__getobject.5)  Find all objects described by an expression.

[includedfiles(mod::Module, candidates::Set{T})](Docile.Collector.md#method__includedfiles.1)  Which source files are known to be included in a module.

[is_aside(block)](Docile.Collector.md#method__is_aside.1)  Is the tuple a valid comment block?

[isdocblock(block)](Docile.Collector.md#method__isdocblock.1)  Does the tuple of expressions represent a valid docstring and associated object?

[isrootfile(mod::Symbol, parsed::Expr)](Docile.Collector.md#method__isrootfile.1)  Is the file the root for a module `mod`. Check for `Expr(:module, ...)`.

[isrootmodule(m::Module)](Docile.Collector.md#method__isrootmodule.1)  Is the module a toplevel one not including the module `Main`?

[location(object::Method)](Docile.Collector.md#method__location.1)  Path to definition of a julia object, only methods are searched for.

[postprocess!(cat::Symbol, metadata, ex)](Docile.Collector.md#method__postprocess.1)  Add some additional metadata for macros and method definitions.

[samemodule(expr, mod)](Docile.Collector.md#method__samemodule.1)  Does the expression `expr` represent the module name `mod`?

[skipexpr(x)](Docile.Collector.md#method__skipexpr.1)  Blacklist some expressions so search doesn't decend into them.

[store!(output, object, docs, metadata)](Docile.Collector.md#method__store.1)  Save docstrings and metadata for the objects that have been found.

[submodules(mod::Module)](Docile.Collector.md#method__submodules.1)  Return the set of all submodules of a given module `mod`.

---

## Types [Internal]

[Docile.Collector.Output](Docile.Collector.md#type__output.1)  Temporary container used for docstring processing. Not the final storage.

## MODULE: Docile.Formats

---

## Methods [Exported]

[parsedocs(::Docile.Formats.Format{F<:Docile.Formats.AbstractFormatter}, raw, mod, obj)](Docile.Formats.md#method__parsedocs.1)  Parsing hook for docstring parsing.

---

## Methods [Internal]

[extractmeta!(text::AbstractString, mod::Module, obj)](Docile.Formats.md#method__extractmeta.1)  Run all 'metamacros' found in a raw docstring and return the resulting string.

[isprefix(io::IO, chars)](Docile.Formats.md#method__isprefix.1)  Does the buffer `io` begin with the given prefix chars?

[isvalid(s::AbstractString)](Docile.Formats.md#method__isvalid.1)  Check that a `MetaMacro`'s `name` is a valid identifier.

[readbracketed(io::IO)](Docile.Formats.md#method__readbracketed.1)  Extract to a string the text between matching brackets `(` and `)`.

[tryextract(io::IO)](Docile.Formats.md#method__tryextract.1)  Try extract an embedded metadata entry name from buffer at current position.

---

## Types [Internal]

[Docile.Formats.MetaMacro{name}](Docile.Formats.md#type__metamacro.1)  Dispatch type for the `metamacro` function. `name` is a `Symbol`.

---

## Macros [Internal]

[@META_str(str)](Docile.Formats.md#macro___meta_str.1)  Shorthand syntax for defining `MetaMacro{<name>}`s as `META"<name>"`.

## MODULE: Docile.Interface

---

## Functions [Exported]

[parsedocs](Docile.Interface.md#function__parsedocs.1)  Parsing hook for specifying how to parse raw docstrings into formatted text.

---

## Methods [Exported]

[category{C}(::Docile.Legacy.Entry{C})](Docile.Interface.md#method__category.1)  What category does an ``Entry`` object belong to?

[data(d::Docile.Legacy.Docs{format})](Docile.Interface.md#method__data.1)  Raw docstring associated with a ``Docs`` object ``d``.

[docs(e::Docile.Legacy.Entry{category})](Docile.Interface.md#method__docs.1)  The ``Docs`` object for an ``Entry`` object ``e``.

[documentation(mod::Module)](Docile.Interface.md#method__documentation.1)  The ``Metadata`` object associated with a module ``mod``.

[documented()](Docile.Interface.md#method__documented.1)  Returns the modules that are currently documented by Docile.

[entries(meta::Docile.Legacy.Metadata)](Docile.Interface.md#method__entries.1)  ``ObjectIdDict`` containing documented objects and their associated ``Entry``s.

[files(meta::Docile.Legacy.Metadata)](Docile.Interface.md#method__files.1)  List of all ``include``d files in a module documented by ``Metadata`` object ``meta``.

[format{F}(d::Docile.Legacy.Docs{F})](Docile.Interface.md#method__format.1)  The format that a docstring is written in.

[isdocumented(mod::Module)](Docile.Interface.md#method__isdocumented.1)  Is the module ``mod`` documented by Docile?

[isexported(modname::Module, object)](Docile.Interface.md#method__isexported.1)  Is the documented object ``object`` been exported from the given module ``modname``?

[isloaded(meta::Docile.Legacy.Metadata)](Docile.Interface.md#method__isloaded.1)  Have the docstrings contained in a module been collected yet?

[manual(meta::Docile.Legacy.Metadata)](Docile.Interface.md#method__manual.1)  The manual files for a ``Metadata`` object ``meta``.

[metadata(e::Docile.Legacy.Entry{category})](Docile.Interface.md#method__metadata.1)  Arbitrary additional metadata associated with a particular ``Entry`` ``e``.

[metadata(meta::Docile.Legacy.Metadata)](Docile.Interface.md#method__metadata.2)  The ``Dict{Symbol, Any}`` containing arbitrary additional data about a ``Metadata`` object.

[metadata(mod::Module)](Docile.Interface.md#method__metadata.3)  Get the ``Metadata`` object associated with a module ``mod``.

[modulename(e::Docile.Legacy.Entry{category})](Docile.Interface.md#method__modulename.1)  Which module does the ``Entry`` object come from?

[modulename(meta::Docile.Legacy.Metadata)](Docile.Interface.md#method__modulename.2)  The ``Module`` that a ``Metadata`` object documents.

[parsed(d::Docile.Legacy.Docs{format})](Docile.Interface.md#method__parsed.1)  Get the parsed docstring for a ``Docs`` object ``d``.

[root(meta::Docile.Legacy.Metadata)](Docile.Interface.md#method__root.1)  The rootfile of the module documented by a ``Metadata`` object ``meta``.

---

## Functions [Internal]

[name](Docile.Interface.md#function__name.1)  Get the ``Symbol`` representing an object such as ``Function`` or ``Method``.

---

## Globals [Internal]

[DOCUMENTED](Docile.Interface.md#global__documented.1)  Storage for deprecated ``Metadata`` documentation.

## MODULE: Docile.Legacy

---

## Macros [Exported]

[@comment(text)](Docile.Legacy.md#macro___comment.1)  Deprecated macro for adding object-independent docstrings to a module.

[@file_str(text)](Docile.Legacy.md#macro___file_str.1)  The text found in the file ``text`` is used as the docstring content.

---

## Methods [Internal]

[call(::Type{Docile.Legacy.Manual}, ::Void, files)](Docile.Legacy.md#method__call.1)  Usage from REPL, use current directory as root.

[data(n, docstr)](Docile.Legacy.md#method__data.1)  Assign to docs to `n` and return a dictionary of keyword arguments.

[doc(s::Symbol, ex::Expr)](Docile.Legacy.md#method__doc.1)  Detect '@doc+' syntax in macro call.

[lateguess(::Function)](Docile.Legacy.md#method__lateguess.1)  Return the category of an object.

[nameof(x::Expr)](Docile.Legacy.md#method__nameof.1)  Get the symbolic name of an expression.

[unarrow(x::Expr)](Docile.Legacy.md#method__unarrow.1)  Extract the docstring and expression to be documented from an `->` expression.

[unblock(x::Expr)](Docile.Legacy.md#method__unblock.1)  Extract the line number and documented object expression from a block.

---

## Macros [Internal]

[@doc(ex)](Docile.Legacy.md#macro___doc.1)  Document an object.

[@init()](Docile.Legacy.md#macro___init.1)  Setup macro-style documentation datastructures.

## MODULE: Docile.Runner

---

## Methods [Exported]

[findmethods(state::Docile.Runner.State, ex::Expr, codesource)](Docile.Runner.md#method__findmethods.1)  Find all methods defined by an method definition expression.

[findtuples(state::Docile.Runner.State, expr::Expr)](Docile.Runner.md#method__findtuples.1)  Find the ``Method`` objects referenced by ``(...)`` docstring syntax.

[findvcats(state::Docile.Runner.State, expr::Expr)](Docile.Runner.md#method__findvcats.1)  Find ``Function`` and ``Method`` objects referenced by ``[...]`` syntax.

[withref(fn, state, ref)](Docile.Runner.md#method__withref.1)  Push reference onto `state`, run function block, and pop reference afterwards.

[withscope(fn, state, scope)](Docile.Runner.md#method__withscope.1)  Push scope onto `state`, run function block, and pop scope afterwards.

---

## Types [Exported]

[Docile.Runner.State](Docile.Runner.md#type__state.1)  Hold state for use with `exec` to determine the objects referenced by symbols.

---

## Methods [Internal]

[addtoscope!(state, var, value)](Docile.Runner.md#method__addtoscope.1)  Add new variable and it's value to topmost scope.

[adjustline(ex::Expr, line)](Docile.Runner.md#method__adjustline.1)  Function expressions have different line numbers depending on whether

[exec(state::Docile.Runner.State, expr::Expr)](Docile.Runner.md#method__exec.1)  Evaluate the expression ``expr`` within the context provided by ``state``.

[funcname(state::Docile.Runner.State, expr::Expr)](Docile.Runner.md#method__funcname.1)  Return the ``Function`` object represented by a method definition expression.

[getargs(expr::Expr)](Docile.Runner.md#method__getargs.1)  Extract the expressions representing a method definition's arguments.

[gettvars(expr::Expr)](Docile.Runner.md#method__gettvars.1)  Extract the expressions from a ``{}`` in a function definition.

[lineinfo(m::Method)](Docile.Runner.md#method__lineinfo.1)  Line number and file name pair for a method ``m``.

## MODULE: Docile

---

## Modules [Exported]

[Docile](Docile.md#module__docile.1)  Documentation extraction package for the Julia Language.

## MODULE: Docile.Utilities

---

## Methods [Internal]

[expandpath(path)](Docile.Utilities.md#method__expandpath.1)  Convert a path to absolute. Relative paths are guessed to be from Julia ``/base``.

[message(msg::AbstractString)](Docile.Utilities.md#method__message.1)  Print a 'Docile'-formatted message to ``STDOUT``.

[samemodule(mod, def::Method)](Docile.Utilities.md#method__samemodule.1)  Is the module where a function/method is defined the same as ``mod``?

---

## Globals [Internal]

[BASE](Docile.Utilities.md#global__base.1)  Path to Julia's base source code.

