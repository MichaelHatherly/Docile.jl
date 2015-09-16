# Internals

## Index

**Builder**

@module{Docile.Builder}

- @ref{Builder}
- @ref{EXTERNAL_FILES}
- @ref{FORMATS}
- @ref{writefile}

**DocTree**

@module{Docile.DocTree}

- @ref{Chunk}
- @ref{Node}
- @ref{exprnode}
- @ref{File}
- @ref{Root}
- @ref{checksizes}
- @ref{expand!}
- @ref{define}
- @ref{getdocs}
- @ref{extractdocs}

**Parser**

@module{Docile.Parser}

- @ref{parsedocs}
- @ref{getname}
- @ref{getbracket}
- @ref{trypeek}
- @ref{trywrite!}

**Queries**

@module{Docile.Queries}

- @ref{INTEGER_REGEX}
- @ref{splitquery}
- @ref{Term}
- @ref{Query}
- @ref{Text}
- @ref{RegexTerm}
- @ref{Object}
- @ref{Metadata}
- @ref{MatchAnyThing}
- @ref{TypeTerm}
- @ref{ArgumentTypes}
- @ref{ReturnTypes}
- @ref{LogicTerm}
- @ref{And}
- @ref{Or}
- @ref{Not}
- @ref{@query_str}
- @ref{Results}
- @ref{exec}
- @ref{score}

**Utilities**

@module{Docile.Utilities}

- @ref{Str}
- @ref{tryget}
- @ref{exports}
- @ref{moduleheader}
- @ref{@get}
- @ref{@S_str}
- @ref{submodules}
- @ref{files}
- @ref{evalblock}
- @ref{parseblock}
- @ref{@object}
- @ref{getobject}
- @ref{getmodule}
- @ref{concat!}
- @ref{msg}

## Details

### `Docile.Builder`

@module{Docile.Builder}

@{
    Builder
    EXTERNAL_FILES
    FORMATS
    writefile
}

### `Docile.DocTree`

@module{Docile.DocTree}

@{
    DocTree
    Chunk
    Node
    exprnode
    File
    Root
    checksizes
    expand!
    define
    getdocs
    extractdocs
}

### `Docile.Parser`

@module{Docile.Parser}

@{
    Parser
    parsedocs
    getname
    getbracket
    trypeek
    trywrite!
}

### `Docile.Queries`

@module{Docile.Queries}

@{
    Queries
    INTEGER_REGEX
    splitquery
    Term
    Query
    Text
    RegexTerm
    Object
    Metadata
    MatchAnyThing
    TypeTerm
    ArgumentTypes
    ReturnTypes
    LogicTerm
    And
    Or
    Not
    @query_str
    Results
    exec
    score
}

### `Docile.Utilities`

@module{Docile.Utilities}

@{
    Utilities
    Str
    tryget
    exports
    moduleheader
    @get
    @S_str
    submodules
    files
    evalblock
    parseblock
    @object
    getobject
    getmodule
    concat!
    msg
}
