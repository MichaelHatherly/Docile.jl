module ExtensionTests

"!!set(name:test)!!get(name)"
set_and_get = ()

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

"!!href(MkDocs:http://www.mkdocs.org/)"
do_href = ()

end
