module Extensions

"""
Methods to extend how Docile handles parsing of docstrings.

These methods could just as easily be defined outside of the package and allow
for package authors to customise how their documentation is presented to users.

Currently content in this module is for experimentation and test purposes only.
"""
Extensions

import ..Formats
import ..Cache

# Just add an entry in the metadata and return the stripped string.
function Formats.metamacro{name}(::Formats.MetaMacro{name}, body, mod, obj)
    Cache.getmeta(mod, obj)[name] = strip(body)
end

# TODO: this is just an example. Should be written better later.
function Formats.metamacro(::Formats.MetaMacro{:format}, body, mod, obj)
    options = [string(p) => p for p in subtypes(Formats.AbstractFormatter)]
    choice  = strip(body)
    for (s, t) in options
        if contains(s, choice)
            Cache.getmeta(mod, obj)[:format] = t
            return ""
        end
    end
    throw(ArgumentError("No formatter found."))
end

end
