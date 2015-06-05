module ExtensionTests

"!!set(name:test)!!get(name)"
set_and_get = ()

"!!var(name:test)"
var = ()

"!!summary(summary)"
summary = ()

"!!longform(...)"
longform = ()

"!!include(includes/file.md)"
includes = ()

"!!set(name:test) !!include(includes/file.md) !!get(name)"
set_includes_get = ()

"!!include(includes/filen_metas.md) Get the inner again: !!get(笔者_inner)"
includes_nested = ()

end
