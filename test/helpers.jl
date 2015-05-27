## Common Test Helpers. ##

meth(f, args) = first(methods(f, args))

fmeth(f) = first(methods(f))

function rawdocs(entries, m)
    m = entries[m]
    Docile.Interface.data(Docile.Interface.docs(m))
end

function docsmeta(entries, k, m)
    m = entries[m]
    Docile.Interface.metadata(m)[k]
end

macrofunc(mod, s) = getfield(mod, symbol(string("@", s)))

qs(mod, sym) = (mod, Docile.Collector.QualifiedSymbol(mod, sym))
