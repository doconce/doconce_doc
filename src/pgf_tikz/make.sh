#!/bin/bash

set -x

function system {
  "$@"
  if [ $? -ne 0 ]; then
    echo "make.sh: unsuccessful command $@"
    echo "abort!"
    exit 1
  fi
}

name="pgf_tikz"
options="--encoding=utf-8 --figure_prefix=fig"

# HTML
system doconce format html $name --html_style=bootstrap_bluegray --html_links_in_new_window $options

# Sphinx
# Problem reproducible after: `git clean -fd && rm -rf sphinx-testdoc`
#Hack: because doconce sphinx_dir ony works the second time (after an error), trigger that error by creating a bogus conf.py in ./
touch conf.py
system doconce format sphinx $name --html_links_in_new_window $options
theme=alabaster
theme=cbc
system doconce sphinx_dir theme=$theme dirname=${theme} $name
python automake_sphinx.py

# LaTeX PDF
system doconce format pdflatex $name --latex_code_style=pyg-blue1 $options
pdflatex -shell-escape -halt-on-error $name
makeindex $name
bibtex $name
pdflatex -shell-escape -halt-on-error $name
pdflatex -shell-escape -halt-on-error $name

# Index page
system doconce format html index --html_style=bootstrap $options

# Publish
dest=../../pub/pgf_tikz
cp *.html *.pdf $dest
cp -r fig $dest
rm -rf $dest/*-${theme}

cp -r ${theme}/_build/html/* $dest/${theme}
