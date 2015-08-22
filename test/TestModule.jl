module TestModule

using Docile

addhook(directives)

"""
@{x}
@{ref:x}
@{esc:ref:x}
@{repl:
julia> a = 1
}
@{example:
a = 1
}
"""
TestModule

end
