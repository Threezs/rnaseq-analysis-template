# renv setup

Run `renv::init()` in the project root, install the exact Bioconductor release needed by the project, then run `renv::snapshot()`. Commit `renv.lock` and the generated activation files; ignore the local library.
