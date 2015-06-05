module RawMetaMacros

import Docile.Formats: metamacro, @META_str

function metamacro(::META"raw_meta"raw, body, mod, obj)
    body
end

function metamacro(::META"nested_meta", body, mod, obj)
    body
end

"!!raw_meta(!!undefined())"
raw_metamacro = ()

"!!nested_meta(!!var(metamacro_type:nestable))"
nested_metamacro = ()

end
