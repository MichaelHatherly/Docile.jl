# Docile File Cache

This folder contains locally parsed and serialized Julia source code. Do not
edit manually. Deleting the contents of this folder, except for the
``README.md`` and ``.gitignore`` files, will reset the cache and is considered a
safe operation.

## Structure

Data is stored by hashed file name as well as ``mtime``. Older versions of files
are automatically removed.
