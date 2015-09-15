# Collect coverage stats and send to Codecov.

cd(Pkg.dir("Docile"))
Pkg.add("Coverage")

import Coverage: Codecov
Codecov.submit(Codecov.process_folder())
