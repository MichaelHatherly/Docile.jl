module ExtensionTests

"!!set(name:test)!!get(name)"
set_and_get = 1

"!!summary(summary)"
summary = 2

"!!longform(...)"
longform = 3

"!!include(includes/file.md)"
includes = 4

"!!set(name:test) !!include(includes/file.md) !!get(name)"
set_includes_get = 5

end
