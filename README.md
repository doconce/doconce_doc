# doconce_pub
This repository contains the documentation file for [DocOnce](https://github.com/doconce/doconce), 
which includes the current repository as a [git-submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules).


### Requirements 
A complete installation of [DocOnce](https://github.com/doconce/doconce). Refer to the instructions there. 

### Folder Structure
* man: man page for doconce

* src: source tree for doconce documentation and examples

* pub: contains compiled documents from the src tree to be
     accessible on the web
     (strictly speaking, pub could only be a dir in gh-pages,
     but we keep master and gh-pages in sync)

* web: entry point for the web pages, with index.html and github
     style files (just github's generated files are here,
     all the doconce material is in pub)

* .TODO: TODO list. This list was compiled from the creator of DocOnce before 2016