#!/bin/bash

latex_admons="mdfbox graybox2 grayicon yellowicon colors1 colors2 paragraph-footnotesize paragraph"
latex_admon_color=bluestyle
#latex_admon_envir_map=
html_admons1="gray yellow apricot lyx colors paragraph paragraph-small"
html_admons2="bootstrap_panel bootstrap_alert"
#html_admon_shadow
#html_admon_bg_color
#html_admon_bd_color
ipynb_admons="quote paragraph hrule"
sphinx_styles="classic agni basicstrap fenics_minimal2 scrolls"


doconce format pdflatex admon --latex_code_style=lst --latex_admon=mdfbox --latex_admon_color=bluestyle "OPTIONS=--latex_admon=mdfbox --latex_admon_color=bluestyle"
pdflatex admon
cp admon.pdf admon_mdfbox_bluestyle.pdf

doconce format pdflatex admon --latex_code_style=lst --latex_admon=mdfbox --latex_section_headings=blue "OPTIONS=--latex_admon=mdfbox --latex_section_headings=blue"
pdflatex admon
cp admon.pdf admon_mdfbox_blue.pdf

for admon_style in $latex_admons; do
doconce format pdflatex admon --latex_code_style=lst --latex_admon=$admon_style "OPTIONS=--latex_admon=$admon_style"
rm -f *.aux
pdflatex admon
cp admon.pdf admon_${admon_style}.pdf
done

for admon_style in $html_admons2; do
doconce format html admon --html_style=bootswatch_readable --html_admon=$admon_style --html_output=admon_${admon_style} "OPTIONS=--html_style=bootswatch_readable --html_admon=$admon_style"
done

for admon_style in $html_admons1; do
if [ $admon_style = "apricot" ]; then
doconce format html admon --html_style=solarized3 --html_admon=$admon_style --html_output=admon_${admon_style} --html_box_shadow "OPTIONS=--html_style=solarized3 --html_admon=$admon_style --html_box_shadow"
else
doconce format html admon --html_style=blueish --html_admon=$admon_style --html_output=admon_${admon_style} --html_box_shadow "OPTIONS=--html_style=blueish --html_admon=$admon_style --html_box_shadow"
fi
done

for admon_style in $ipynb_admons; do
doconce format ipynb admon --ipynb_admon=$admon_style "OPTIONS=--ipynb_admon=$admon_style"
cp admon.ipynb admon_${admon_style}.ipynb
done

doconce format sphinx admon --sphinx_keep_splits "OPTIONS=None"
# Problem reproducible after: `git clean -fd && rm -rf sphinx-testdoc`
#Hack: because doconce sphinx_dir ony works the second time (after an error), trigger that error by creating a bogus conf.py in ./
touch conf.py
doconce sphinx_dir theme=default admon
python automake_sphinx.py
cd sphinx-rootdir
bash make_themes.sh $sphinx_styles
cd ..

doconce pygmentize admon.do.txt
doconce format html index --html_style=bootstrap --html_links_in_new_window latex_admons="$latex_admons" html_admons1="$html_admons1" html_admons2="$html_admons2" ipynb_admons="$ipynb_admons"

# Publish
dest=../../pub/admon
cp -r admon_*.pdf admon_*.html admon_*.ipynb index.html admon.do.txt.html $dest
cp -r sphinx-rootdir/sphinx-* $dest
