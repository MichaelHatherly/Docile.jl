# Docile


## Modules [Exported]

---

<a id="module__docile.1" class="lexicon_definition"></a>
#### Docile [¶](#module__docile.1)
Documentation extraction package for the Julia Language.

Docile supports several styles of docstring. Namely:

The original ``@doc`` macro, which is now also available in Julia ``0.4``:

    using Docile

    @doc """
    ...
    """ ->
    f(x) = x

Plain strings using the ``@document`` macro. Requires importing ``Docile`` into
the module:

    using Docile
    @document

    """
    ...
    """
    f(x) = x

Automatic extraction for plain docstrings from packages that have been
``import``ed:

    """
    ...
    """
    f(x) = x

The third style is the newest, and preferred, way to document packages in a
Docile-compatible way. ``@doc`` and ``@document`` docstring usage will remain
part of Docile for the foreseeable future to allow for backward compatibility.


*source:*
[Docile/src/Docile.jl:40](https://github.com/MichaelHatherly/Docile.jl/tree/7701224579bea92e6ad5f70a3c2da426c0a1dce7/src/Docile.jl#L40)

