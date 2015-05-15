### Metamacros

Docile provides a user-extensible text substitution macro system, called "metamacros", that can be
used to perform arbitrary textual manipulation and replacement in docstrings prior to parsing and
displaying them. A metamacro also provides access to the object and module associated with the
docstring in which it is written.

#### Metamacro Syntax

Metamacros use the syntax ``!!<NAME>(<TEXT>)``.

* A `!!` double exclamation mark prefix begins a metamacro.
* `<NAME>` must be a valid Julia identifier.
* `(` opening bracket
* `<TEXT>` is optional and can contain arbitrary text.
* `)` closing bracket

Example:

```julia
"""

!!hypothetical()

!!set(author:Author's Name)

!!get(author)

!!setget(author:Author's Name)

!!summary(Set the value for a field in an object's metadata.)

!!longform(
...
)

"""
```

Metamacros can be nested.

Example:

```julia
"""

!!summary(Set the value for a field in an object's metadata. !!set(url:https://github.com/MichaelHatherly/Docile.jl))


!!setget(outer:Outer
    !!setget(level1:Level1
        !!setget(level2:Level2
            !!setget(level3:Level3
                !!setget(level4:Level4
                    !!setget(level5:Level5
                        !!setget(level6:Level6)))))))

"""
```


##### Escape for the metamacro syntax

To escape the metamacro syntax a double backslash is used immidiately before the `!!` double
exclamation mark. This does not escape any nested metamacros.

Example:

```julia
"""

\\!!hypothetical()

\\!!set(author:Author's Name)

!!summary(Set the value for a field in an object's metadata. \\!!set(url:https://github.com/MichaelHatherly/Docile.jl))

"""
```

#### Metamacro definitions

Docile comes with a couple of *metamacro definitions* in `src/Extensions` folder.
Package authors can add their own to customise how their documentation is presented to users.

For example such definitions can be added to a docile package configuration file: `.docile`.

**Return Values**

Metamacro methods must return a string which is spliced back into the docstring in place of the
`metamacro syntax`.

The returned string, which can also be an empty string, replaces everything starting with
the `!!` up to and including the closing parentheses.
