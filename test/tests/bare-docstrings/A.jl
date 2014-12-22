"One line, type doc."
type T1
end

"One line, abstract doc."
abstract T2

"""
Multiline, type doc.
"""
type T3
end

"""
Multiline, abstract doc.
"""
abstract T4

include("B.jl")

"One line, constant doc."
const C1 = 1

"""
Multiline, constant doc.
"""
const C2 = 2

"One line, global doc."
C3 = 3

"""
Multiline, global doc.
"""
C4 = 4

module InnerModuleB

@docstrings(key = "value") # Overriding default module metadata.

"One line, method documentation in an inner module."
function b(x)
    x
end

end
