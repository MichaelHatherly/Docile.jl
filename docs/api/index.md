# API-INDEX


## MODULE: Docile

---

## Methods [Exported]

[meta()](Docile.md#method__meta.1)  Add additional metadata to a documented object.

[meta(doc)](Docile.md#method__meta.2)  Add additional metadata to a documented object.

---

## Macros [Exported]

[@comment(text)](Docile.md#macro___comment.1)  Add additional commentary to source code unrelated to any particular object.

[@doc(args...)](Docile.md#macro___doc.1)  Document objects in source code such as *functions*, *methods*, *macros*,

[@docstrings(args...)](Docile.md#macro___docstrings.1)  Module documentation initialiser. Optional.

[@document(options...)](Docile.md#macro___document.1)  Macro used to setup documentation for the current module.

[@file_str(path)](Docile.md#macro___file_str.1)  Provide a file path to the contents of a docstring.

---

## Functions [Internal]

[addentry!](Docile.md#function__addentry.1)  Add object or set of objects and corresponding `Entry` object to a module.

---

## Methods [Internal]

[builddocs!(meta)](Docile.md#method__builddocs.1)  Parse `root` and `files`, adding available docstrings to `objects`.

[call(::Type{Docile.Manual}, ::Void, files)](Docile.md#method__call.1)  Usage from REPL, use current directory as root.

[call(::Type{Docile.Metadata}, root::AbstractString, data::Dict{K, V})](Docile.md#method__call.2)  Convenience constructor for `Metadata` type that initializes default values for

[call{category}(::Type{Docile.Entry{category}}, modname::Module, source, doc::AbstractString)](Docile.md#method__call.3)  Convenience constructor for simple string docs.

[call{category}(::Type{Docile.Entry{category}}, modname::Module, source, doc::Docile.Docs{format})](Docile.md#method__call.4)  For md"" etc. -style docstrings.

[call{category}(::Type{Docile.Entry{category}}, modname::Module, source, tup::Tuple)](Docile.md#method__call.5)  Handle the `meta` method syntax for `@doc`.

[call{format}(::Type{Docile.Docs{format}}, data::AbstractString)](Docile.md#method__call.6)  Lazy `obj` field access which leaves the `obj` field undefined until first accessed.

[call{format}(::Type{Docile.Docs{format}}, docs::Docile.Docs{format})](Docile.md#method__call.7)  Pass `Doc` objects straight through. Simplifies code in `Entry` constructors.

[call{format}(::Type{Docile.Docs{format}}, file::Docile.File)](Docile.md#method__call.8)  Read a file's contents as the docstring.

[docstar(symb::Symbol, args...)](Docile.md#method__docstar.1)  Attaching metadata to the generic function rather than the specific method which

[exec(state::Docile.State, ex::Expr)](Docile.md#method__exec.1)  Execute expression `ex` in the context provided by `state`.

[externaldocs(mod, meta)](Docile.md#method__externaldocs.1)  Guess doc format from file extension. Entry docstring created when file does not exist.

[findmethods(state::Docile.State, ex::Expr)](Docile.md#method__findmethods.1)  Return set of methods defined by an expression `ex` as if it had been evaluated.

[findmodule(ast, modname)](Docile.md#method__findmodule.1)  Recursively walk an expression searching for a module with the correct name.

[findsource(obj)](Docile.md#method__findsource.1)  Returns the line number and filename of the documented object. This is based on

[findtuples(state::Docile.State, ex::Expr)](Docile.md#method__findtuples.1)  Get all methods from a quoted tuple of the form `(function, T1, T2, ...)`.

[format(file)](Docile.md#method__format.1)  Extract the format of a file based *solely* of the file's extension.

[funccall(ex::Expr)](Docile.md#method__funccall.1)  Extract the `Expr(:call, ...)` from the given `ex`.

[funcname(state::Docile.State, ex::Expr)](Docile.md#method__funcname.1)  Return the `Function` object contained in expression `ex`.

[getargs(ex::Expr)](Docile.md#method__getargs.1)  Extract quoted argument expressions from a method call expression.

[getdoc(modname)](Docile.md#method__getdoc.1)  Return the Metadata object stored in a module.

[gettvars(ex::Expr)](Docile.md#method__gettvars.1)  Extract quoted type parameters from an expression.

[include!(meta, path)](Docile.md#method__include.1)  Method used to override the behavior of `include`.

[includedast(meta)](Docile.md#method__includedast.1)  Extract docstrings from the AST of included files.

[isdocblock(block)](Docile.md#method__isdocblock.1)  Is the given triplet `block` a valid documentation block.

[issymbol(s::Symbol)](Docile.md#method__issymbol.1)  Handle modules and functions as symbols at later stage.

[lateguess(curmod, symb)](Docile.md#method__lateguess.1)  What does the symbol ``symb`` represent in the current module ``curmod``?

[macroname(ex)](Docile.md#method__macroname.1)  Symbol representing a macro call to the specified macro `ex`.

[name(ex::Expr)](Docile.md#method__name.1)  Extract the symbol identifying an expression.

[object_category(ex)](Docile.md#method__object_category.1)  What does the expression `ex` represent? Can it be documented? :symbol is used

[object_ref(cat, meta, state, ex)](Docile.md#method__object_ref.1)  Get the object/objects created by an expression in the given module.

[parsefile(file)](Docile.md#method__parsefile.1)  Read contents of `file` and parse it into an expression.

[popref!(state::Docile.State)](Docile.md#method__popref.1)  Remove the object from the top of `state`'s index references stack.

[popscope!(state::Docile.State)](Docile.md#method__popscope.1)  Remove the scope from the top of `state`'s scopes stack.

[postprocess_entry!(cat::Symbol, meta, ent, ex)](Docile.md#method__postprocess_entry.1)  Add additional metadata to an entry based on the category of the entry.

[processast(meta, state, file, ex::Expr)](Docile.md#method__processast.1)  Gather valid documentation from a given expression `ex`.

[processblock(meta, state, file, block)](Docile.md#method__processblock.1)  Collect object and docstring `Entry` object from a valid documentation block.

[pushmeta!(doc::Docile.Metadata, object, entry::Docile.Entry{category})](Docile.md#method__pushmeta.1)  Warn the author about overwritten metadata.

[pushref!(state::Docile.State, object)](Docile.md#method__pushref.1)  Push an object onto the top of a `state`'s index references stack.

[pushscope!(state::Docile.State, scope::Dict{K, V})](Docile.md#method__pushscope.1)  Add a new scope to top of `state`'s stack of scopes.

[qualifiedname(ex::Expr)](Docile.md#method__qualifiedname.1)  Returns as a tuple the module name as well as the full method name.

[readdocs(file)](Docile.md#method__readdocs.1)  Load and apply format based on extension to the given `filename`.

[register!(modname)](Docile.md#method__register.1)  Register a module `modname` as 'documented' with Docile.

[rootast(meta)](Docile.md#method__rootast.1)  Extract docstrings from the AST found in the root file of a module.

[separate(expr)](Docile.md#method__separate.1)  Split the expressions passed to `@doc` into data and object. The docstring and

[setmeta!(modname, object, category, source, args...)](Docile.md#method__setmeta.1)  Metatdata interface for *single* objects. `args` is the docstring and metadata dict.

[setmeta!(modname, objects::Set{T}, category, source, args...)](Docile.md#method__setmeta.2)  For varargs method definitions since they generate multiple method objects. Use

[unravel(entries, meta, state, file, ex::Expr)](Docile.md#method__unravel.1)  Execute for-loops containing `@eval` blocks and retrieve documented objects.

---

## Types [Internal]

[Docile.Docs{format}](Docile.md#type__docs.1)  Lazy-loading documentation object. Initially the raw documentation string is

[Docile.Entry{category}](Docile.md#type__entry.1)  Type representing a docstring and associated metadata in the

[Docile.Metadata](Docile.md#type__metadata.1)  Container type used to store a module's metadata collected by Docile.

[Docile.State](Docile.md#type__state.1)  The `State` type holds the data for evaluating expressions using `exec`.

## MODULE: Docile.Interface

---

## Methods [Exported]

[category{C}(e::Docile.Entry{C})](Docile.Interface.md#method__category.1)  Symbol representing the category that an `Entry` belongs to.

[data(d::Docile.Docs{format})](Docile.Interface.md#method__data.1)  The raw content stored in a docstring.

[docs(e::Docile.Entry{category})](Docile.Interface.md#method__docs.1)  Documentation related to the entry.

[documented()](Docile.Interface.md#method__documented.1)  Returns the modules that are currently documented by Docile.

[entries(meta::Docile.Metadata)](Docile.Interface.md#method__entries.1)  Dictionary associating objects and documentation entries.

[files(meta::Docile.Metadata)](Docile.Interface.md#method__files.1)  All files `include`d in the module documented with the `meta` object.

[format{F}(d::Docile.Docs{F})](Docile.Interface.md#method__format.1)  Return the format that a docstring is written in.

[isdocumented(mod::Module)](Docile.Interface.md#method__isdocumented.1)  Is the given module `modname` documented using Docile?

[isexported(modname::Module, object)](Docile.Interface.md#method__isexported.1)  Check whether `object` has been exported from a *documented* module `modname`.

[isloaded(meta::Docile.Metadata)](Docile.Interface.md#method__isloaded.1)  Has the documentation contained in a module been loaded into the `meta` object?

[manual(meta::Docile.Metadata)](Docile.Interface.md#method__manual.1)  The `Manual` object containing a module's manual pages.

[metadata(e::Docile.Entry{category})](Docile.Interface.md#method__metadata.1)  Dictionary containing arbitrary metadata related to an entry.

[metadata(meta::Docile.Metadata)](Docile.Interface.md#method__metadata.2)  A dictionary containing configuration settings related to the `meta` object.

[metadata(mod::Module)](Docile.Interface.md#method__metadata.3)  Returns the `Metadata` object stored in a module `modname` by Docile.

[modulename(e::Docile.Entry{category})](Docile.Interface.md#method__modulename.1)  Module where the entry is defined.

[modulename(meta::Docile.Metadata)](Docile.Interface.md#method__modulename.2)  Module where the `Metadata` object is defined.

[parsed(d::Docile.Docs{format})](Docile.Interface.md#method__parsed.1)  The parsed documentation for an object. Lazy parsing.

[parsedocs{ext}(d::Docile.Docs{ext})](Docile.Interface.md#method__parsedocs.1)  Extension method for handling arbitrary docstring formats.

[root(meta::Docile.Metadata)](Docile.Interface.md#method__root.1)  File containing the module definition documented with the `meta` object.

