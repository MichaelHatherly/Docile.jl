# Early tests -- keep around for now.
module OldTests

using Docile

@doc meta(file = "test-case.md", section = "Tests") ->
function g(x)
end

@doc meta(md"""
The `md` multiline string allows Latex input without escaping
characters.

$$
\frac{a + b}{a - b}
$$

Some more text.
""", key = :value) ->
h(x) = x

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut tristique
vitae, sagittis vel odio. Maecenas convallis ullamcorper ultricies.

```julia
a = 2
b = 3
a + b
```
""", key = :value) ->
function f(x::Int)
end

@doc meta("""
Nam dictum, odio nec pretium volutpat, arcu ante placerat erat, non
tristique elit urna et turpis. Quisque mi metus, ornare sit amet
fermentum et, tincidunt et orci. Fusce eget orci a orci congue
vestibulum.

A code block that runs:

```julia
a = rand(10,10)
b = rand(10)
a * b
```

A code block that fails:

```julia
sqrt(-1)
```

""", parameters = [(:x, "the real argument")]) ->
f(x::Real) = x

@doc """
Suspendisse lectus leo, consectetur in tempor sit amet, placerat quis
neque. Etiam luctus porttitor lorem, sed suscipit est rutrum non.
Curabitur lobortis nisl a enim congue semper. Aenean commodo ultrices
imperdiet. Vestibulum ut justo vel sapien venenatis tincidunt. Phasellus
eget dolor sit amet ipsum dapibus condimentum vitae quis lectus. Aliquam
ut massa in turpis dapibus convallis.

* one
* two
* three
* four

""" ->
function f(x::Float64)
end

@doc """
Nam dictum, odio nec pretium volutpat, arcu ante placerat erat, non
tristique elit urna et turpis.

```julia
a = rand(5,5)
@show @which f(a)
```
""" ->
f(x::Matrix) = x^2

## types ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@doc meta("""
Suspendisse lectus leo, consectetur in tempor sit amet, placerat quis
neque. Etiam luctus porttitor lorem, sed suscipit est rutrum non.
Curabitur lobortis nisl a enim congue semper. Aenean commodo ultrices
imperdiet.
""", tags = ["one", "two", "three"]) ->
abstract FooAbs1

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut tristique
vitae, sagittis vel odio. Maecenas convallis ullamcorper ultricies.
Curabitur ornare, ligula semper consectetur sagittis, nisi diam iaculis
velit, id fringilla sem nunc vel mi.
""" ->
abstract FooAbs2

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
abstract FooAbs3{S}

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
abstract FooAbs4{S}

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
abstract Foo1 <: FooAbs1

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
abstract Foo2 <: FooAbs2

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
typealias Foo3 Int

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
typealias Foo4 Int

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
immutable Foo5
end

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
immutable Foo6
end

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
immutable Foo7 <: FooAbs1
end

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
immutable Foo8 <: FooAbs2
end

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
immutable Foo9{T}
end

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
immutable Foo10{T}
end

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
immutable Foo11{T} <: FooAbs1
end

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
immutable Foo12{T} <: FooAbs2
end

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
immutable Foo13{T,S} <: FooAbs3{S}
end

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
immutable Foo14{T,S} <: FooAbs4{S}
end

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
type Foo15
end

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
type Foo16
end

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
type Foo17 <: FooAbs1
end

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
type Foo18 <: FooAbs2
end

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
type Foo19{T}
end

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
type Foo20{T}
end

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
type Foo21{T} <: FooAbs1
end

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
type Foo22{T} <: FooAbs2
end

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
type Foo23{T,S} <: FooAbs3{S}
end

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
type Foo24{T,S} <: FooAbs4{S}
end

## macros –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
macro foo(args)
end

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
macro foo(args)
end

## constants ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@doc meta(""" Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
const FOO = "foo"

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
const FOO = "foo"

## globals ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
global FOO = "foo"

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
global FOO = "foo"

## global constants –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
global const FOO = "foo"

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
global const FOO = "foo"

## non constants ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
FOO = "foo"

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
FOO = "foo"

## symbols (functions and modules) ––––––––––––––––––––––––––––––––––––––––––––––––––––––

@doc meta("""
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""", key = :value) ->
f

@doc """
Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut
tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper
ultricies. Curabitur ornare, ligula semper consectetur sagittis, nisi
diam iaculis velit, id fringilla sem nunc vel mi.
""" ->
g

@doc meta("""
Documentation for the Module itself.
""", tags = ["One", "Two", "Three"]) ->
OldTests

# fix for `@doc` with no docstring
@doc meta(file = "test-case.md") ->
function h(x, y, z)

end
@doc meta(file = "test-case.md") ->
type FooBar30

end

@doc meta(file = "test-case.md") ->
abstract FooBar31

@doc meta(file = "test-case.md") ->
global const FOOBAR1 = 4

@doc meta(file = "test-case.md") ->
const FOOBAR2 = 4

@doc meta(file = "test-case.md") ->
FOOBAR3 = 4

@doc meta(file = "test-case.md") ->
h(x, y, z) = x

end

@test modulename(documentation(OldTests)) === OldTests
