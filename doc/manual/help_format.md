# Help Format

*Preliminary ideas for format. Subject to change.*

## General comments

Format specification of help files in `PACKAGE/doc/help`.

Extension should be `.md` such that they are readable directly from
webites such as GitHub, etc.

No strict folder structure needed. All `.md` files are parsed and the
first line header used as metadata. All other files are ignored. This
allows the functions in a module to be spread over multiple files if
there are a substantial amount. Filenames may be used to specify, for
instance, the topic or area covered by a particular group of functions.

Files should contain legal markdown syntax only. Extensions including
tables and latex math (mathjax) possibly.

## Help file structure

The first line (header) of each file contains the full module path of
all entries documented in the file.

Examples:

* `# Docile`
* `# Base.Help`
* `# Very.Long.Module.Path`

The rest of the file contains entries from the module specified in the
header. An entry is defined as a function, macro, (constant, or type
declaration).

Each entry starts on a new line with a `##` as follows:

* `## init(package::String)`
* `## @printf([io::IOStream], "%Fmt", args...)`
* `## isempty(collection) -> Bool`

Syntax for these signatures does not need to be parsable as julia code.
Inspiration is drawn from the standard library documentation in this
regard.

The body text of an entry is freeform and may contain any markdown
syntax except for `#`-style headers.

After the body text several special sections are available for use. They
start with a `###` on a new line. Choices may include:

* `### Example:`
* others ...

`### Example` begins a section of code. The code itself must be indented
4 spaces like markdown. A line beginning with `julia>` acts the same way
as the REPL in that the output is printed on the next line unless a `;`
terminates the line. Lines without `julia>` output the result of the
last expression in the particular code block. As such it may be better
to not mix the two.

Any number of `### Example` sections may appear in an entry and are
autonumbered and given a group heading `Examples:` in the parsed output.
Comments are used in the code blocks for explanations to allow for ease
of copying into a REPL or elsewhere.

All code blocks is/can be executed during compilation for correctness
checks. For storing the output of examples execution is (obviously)
required.

Each example should be self-contained and not reference other examples.
Examples are run in a clean modules. If the first comment in an example
begins with `#in name` where `name` is a legal module name then the code
is evaluated there along with all other examples with the same `name`.

`STDOUT`, and maybe `STDERR` as well, should be redirected to the generated output.

## Output type roadmap

1. helpdb.jl
2. markdown, since the markdown in the authored files doesn't render too nicely.
3. markdown -> anything that an external tool can handle.
