# Docile.Runner


## Methods [Exported]

---

<a id="method__findmethods.1" class="lexicon_definition"></a>
#### findmethods(state::Docile.Runner.State, ex::Expr, codesource) [¶](#method__findmethods.1)
Find all methods defined by an method definition expression.

    "A docstring for the methods ``f(::Any)`` and ``f(::Any, ::Any)``"
    f(x, y = 1) = x + y



*source:*
[Docile/src/Runner/lookup.jl:10](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/lookup.jl#L10)

---

<a id="method__findtuples.1" class="lexicon_definition"></a>
#### findtuples(state::Docile.Runner.State, expr::Expr) [¶](#method__findtuples.1)
Find the ``Method`` objects referenced by ``(...)`` docstring syntax.

    "Shared docstring for all 2 argument methods, first argument an ``Int``."
    (foo, Int, Any)



*source:*
[Docile/src/Runner/lookup.jl:48](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/lookup.jl#L48)

---

<a id="method__findvcats.1" class="lexicon_definition"></a>
#### findvcats(state::Docile.Runner.State, expr::Expr) [¶](#method__findvcats.1)
Find ``Function`` and ``Method`` objects referenced by ``[...]`` syntax.

    "Shared docstring for differently named functions."
    [foobar, foobar!]



*source:*
[Docile/src/Runner/lookup.jl:67](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/lookup.jl#L67)

---

<a id="method__withref.1" class="lexicon_definition"></a>
#### withref(fn, state, ref) [¶](#method__withref.1)
Push reference onto `state`, run function block, and pop reference afterwards.


*source:*
[Docile/src/Runner/state.jl:35](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/state.jl#L35)

---

<a id="method__withscope.1" class="lexicon_definition"></a>
#### withscope(fn, state, scope) [¶](#method__withscope.1)
Push scope onto `state`, run function block, and pop scope afterwards.


*source:*
[Docile/src/Runner/state.jl:20](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/state.jl#L20)

## Types [Exported]

---

<a id="type__state.1" class="lexicon_definition"></a>
#### Docile.Runner.State [¶](#type__state.1)
Hold state for use with `exec` to determine the objects referenced by symbols.


*source:*
[Docile/src/Runner/state.jl:4](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/state.jl#L4)


## Methods [Internal]

---

<a id="method__addtoscope.1" class="lexicon_definition"></a>
#### addtoscope!(state, var, value) [¶](#method__addtoscope.1)
Add new variable and it's value to topmost scope.


*source:*
[Docile/src/Runner/state.jl:52](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/state.jl#L52)

---

<a id="method__adjustline.1" class="lexicon_definition"></a>
#### adjustline(ex::Expr, line) [¶](#method__adjustline.1)
Function expressions have different line numbers depending on whether
they are "full" or "short":

    f(x) = x

    function g(x)
        x
    end

``f`` will have a ``.line`` value pointing to the start of the expression, while
``g``'s ``.line`` value will point at the first line of the function's body.


*source:*
[Docile/src/Runner/lookup.jl:34](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/lookup.jl#L34)

---

<a id="method__exec.1" class="lexicon_definition"></a>
#### exec(state::Docile.Runner.State, expr::Expr) [¶](#method__exec.1)
Evaluate the expression ``expr`` within the context provided by ``state``.


*source:*
[Docile/src/Runner/lookup.jl:89](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/lookup.jl#L89)

---

<a id="method__funcname.1" class="lexicon_definition"></a>
#### funcname(state::Docile.Runner.State, expr::Expr) [¶](#method__funcname.1)
Return the ``Function`` object represented by a method definition expression.


*source:*
[Docile/src/Runner/lookup.jl:167](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/lookup.jl#L167)

---

<a id="method__getargs.1" class="lexicon_definition"></a>
#### getargs(expr::Expr) [¶](#method__getargs.1)
Extract the expressions representing a method definition's arguments.


*source:*
[Docile/src/Runner/lookup.jl:161](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/lookup.jl#L161)

---

<a id="method__gettvars.1" class="lexicon_definition"></a>
#### gettvars(expr::Expr) [¶](#method__gettvars.1)
Extract the expressions from a ``{}`` in a function definition.


*source:*
[Docile/src/Runner/lookup.jl:156](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/lookup.jl#L156)

---

<a id="method__lineinfo.1" class="lexicon_definition"></a>
#### lineinfo(m::Method) [¶](#method__lineinfo.1)
Line number and file name pair for a method ``m``.


*source:*
[Docile/src/Runner/lookup.jl:39](https://github.com/MichaelHatherly/Docile.jl/tree/480e42d83ca456d56827d0f3c518ee109b0fef3b/src/Runner/lookup.jl#L39)

