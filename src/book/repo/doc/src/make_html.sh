#!/bin/sh
set -x

name=book
topicname=my
encoding='--encoding=utf-8'

function system {
  "$@"
  if [ $? -ne 0 ]; then
    echo "make.sh: unsuccessful command $@"
    echo "abort!"
    exit 1
  fi
}

rm -rf tmp_* *.dolog
pwd
preprocess -DFORMAT=html newcommands.p.tex > newcommands.tex

opt="--exercise_numbering=chapter"

# --- Let's compile a lot of formats before we have decided for one HTML
# and one Sphinx

hash=82dee82e1274a586571086dca04d00308d3a0d86  # "book with solutions"
# Compile Bootstrap HTML with solutions
html=.trash${hash}
system doconce format html $name $opt --html_style=bootstrap_simula --html_admon=bootstrap_panel --html_code_style=inherit "--html_body_style=font-size:20px;line-height:1.5" --html_output=$html $encoding --exercise_solution=admon #--without_solutions --without_answers
cp $html.html tmp.html
system doconce split_html $html.html
#cp password.html ${topicname}-book-sol.html
cp $html.html ${topicname}-book-sol.html
#doconce replace DESTINATION "$html" ${topicname}-book-sol.html
#doconce replace PASSWORD "s!c!ale" ${topicname}-book-sol.html

# Compile Bootstrap HTML in bluegray style without answers
html=${topicname}-book
system doconce format html $name $opt --html_style=bootstrap_bluegray --html_admon=bootstrap_panel --html_code_style=inherit "--html_body_style=font-size:20px;line-height:1.5" --html_output=$html --without_solutions --without_answers $encoding
system doconce split_html $html.html

# Compile Bootstrap HTML in readable style
html=${topicname}-book2
system doconce format html $name $opt --html_style=bootswatch_readable --html_admon=bootstrap_panel --html_code_style=inherit "--html_body_style=font-size:20px;line-height:1.5" --html_output=$html $encoding
system doconce split_html $html.html

# Compile Bootstrap HTML in bluegray style
html=${topicname}-book3
system doconce format html $name $opt --html_style=bootstrap_bluegray --html_admon=bootstrap_panel --html_code_style=inherit "--html_body_style=font-size:20px;line-height:1.5" --html_output=$html $encoding
system doconce split_html $html.html

# Compile solarized HTML
html=${topicname}-book-solarized
system doconce format html $name $opt --html_style=solarized3 --html_output=$html --without_solutions --without_answers $encoding
system doconce split_html $html.html --nav_button=text

# Sphinx styles
themes="uio2 bootstrap"
for theme in $themes; do
system doconce format sphinx $name $opt --without_solutions --without_answers $encoding --toc_depth=2 # --sphinx_keep_splits
system doconce split_rst $name
system doconce sphinx_dir theme=$theme dirname=sphinx-${theme} $name
system python automake_sphinx.py
done


# Publish
repo=../pub
dest=${repo}/book
if [ ! -d $dest ]; then mkdir $dest; fi
if [ ! -d $dest/html ]; then mkdir $dest/html; fi
#if [ ! -d $dest/sphinx ]; then mkdir $dest/sphinx; fi

cp *book*.html ._*book*.html .*trash*.html $dest/html
figdirs="fig-* mov-*"
for figdir in $figdirs; do
    # slash important for copying files in links to dirs
    if [ -d $figdir/ ]; then
        cp -r $figdir/ $dest/html
    fi
done
rm -fr $dest/sphinx-*
for dir in sphinx-*; do
 cp -r $dir/_build/html ${dest}/$dir
done

cd $dest
git add .
