module ExtensionTests

"!!set(name:test)!!get(name)"
set_and_get = ()

"!!get(notset)"
get_notset = ()

"!!setget(name:test)"
setget = ()

"!!summary(summary)"
summary = ()

"!!longform(...)"
longform = ()

"!!include(includes/file.md)"
includes = ()

"!!set(name:test) !!include(includes/file.md) !!get(name)"
set_includes_get = ()

end
