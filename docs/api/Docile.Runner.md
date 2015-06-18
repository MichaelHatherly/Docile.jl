# Docile.Runner


## Methods [Exported]

---

<a id="method__findmethods.1" class="lexicon_definition"></a>
#### findmethods(state::Docile.Runner.State,  ex::Expr,  codesource) [¶](#method__findmethods.1)
Find all methods defined by an method definition expression.

    "A docstring for the methods ``f(::Any)`` and ``f(::Any, ::Any)``"
    f(x, y = 1) = x + y



*source:*
[Docile/src/Runner/lookup.jl:10](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Runner/lookup.jl#L10)

---

<a id="method__findtuples.1" class="lexicon_definition"></a>
#### findtuples(state::Docile.Runner.State,  expr::Expr) [¶](#method__findtuples.1)
Find the ``Method`` objects referenced by ``(...)`` docstring syntax.

    "Shared docstring for all 2 argument methods, first argument an ``Int``."
    (foo, Int, Any)



*source:*
[Docile/src/Runner/lookup.jl:45](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Runner/lookup.jl#L45)

---

<a id="method__findvcats.1" class="lexicon_definition"></a>
#### findvcats(state::Docile.Runner.State,  expr::Expr) [¶](#method__findvcats.1)
Find ``Function`` and ``Method`` objects referenced by ``[...]`` syntax.

    "Shared docstring for differently named functions."
    [foobar, foobar!]



*source:*
[Docile/src/Runner/lookup.jl:64](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Runner/lookup.jl#L64)

---

<a id="method__withref.1" class="lexicon_definition"></a>
#### withref(fn,  state,  ref) [¶](#method__withref.1)
Push reference onto `state`, run function block, and pop reference afterwards.


*source:*
[Docile/src/Runner/state.jl:25](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Runner/state.jl#L25)

## Types [Exported]

---

<a id="type__state.1" class="lexicon_definition"></a>
#### Docile.Runner.State [¶](#type__state.1)
Hold state for use with `exec` to determine the objects referenced by symbols.


*source:*
[Docile/src/Runner/state.jl:4](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Runner/state.jl#L4)


## Methods [Internal]

---

<a id="method__addtoscope.1" class="lexicon_definition"></a>
#### addtoscope!(state,  var,  value) [¶](#method__addtoscope.1)
Add new variable and it's value to topmost scope.


*source:*
[Docile/src/Runner/state.jl:42](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Runner/state.jl#L42)

---

<a id="method__exec.1" class="lexicon_definition"></a>
#### exec(state::Docile.Runner.State,  expr::Expr) [¶](#method__exec.1)
Evaluate the expression ``expr`` within the context provided by ``state``.


*source:*
[Docile/src/Runner/lookup.jl:86](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Runner/lookup.jl#L86)

---

<a id="method__funcname.1" class="lexicon_definition"></a>
#### funcname(state::Docile.Runner.State,  expr::Expr) [¶](#method__funcname.1)
Return the ``Function`` object represented by a method definition expression.


*source:*
[Docile/src/Runner/lookup.jl:164](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Runner/lookup.jl#L164)

---

<a id="method__getargs.1" class="lexicon_definition"></a>
#### getargs(expr::Expr) [¶](#method__getargs.1)
Extract the expressions representing a method definition's arguments.


*source:*
[Docile/src/Runner/lookup.jl:158](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Runner/lookup.jl#L158)

---

<a id="method__gettvars.1" class="lexicon_definition"></a>
#### gettvars(expr::Expr) [¶](#method__gettvars.1)
Extract the expressions from a ``{}`` in a function definition.


*source:*
[Docile/src/Runner/lookup.jl:153](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Runner/lookup.jl#L153)

---

<a id="method__lineinfo.1" class="lexicon_definition"></a>
#### lineinfo(m::Method) [¶](#method__lineinfo.1)
Line number and file name pair for a method ``m``.


*source:*
[Docile/src/Runner/lookup.jl:36](https://github.com/MichaelHatherly/Docile.jl/tree/97ae2f5b73219df03bb61b77eae68932348f4c95/src/Runner/lookup.jl#L36)

