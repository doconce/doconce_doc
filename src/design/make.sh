#!/bin/sh
pub=../../pub/design
templates=../../../bundled/html_styles

# Compile plain HTML demo doc
doconce format html mydoc.do.txt
pygmentize -f html -O full,style=emacs -o mydoc_plain_pygmentized.html -l html mydoc.html
cp mydoc.html $pub/mydoc_plain.html
cp mydoc_plain_pygmentized.html $pub
cp -r fig $pub/

# Utilize the GitHub theme "minimal" as template
doconce format html mydoc.do.txt --html_template=github_template/template_github_minimal.html
pygmentize -f html -O full,style=emacs -o mydoc_github_pygmentized.html -l html mydoc.html
pygmentize -f html -O full,style=emacs -o template_github_minimal_pygmentized.html -l html github_template/template_github_minimal.html
cp mydoc.html $pub/mydoc_github.html
cp -r mydoc_github_pygmentized.html $pub/

# Utilize the template made from 5620.html
doconce format html mydoc.do.txt --html_template=uio/template_5620.html
cp mydoc.html $pub/mydoc_uio.html
cp -r uio $pub/

# Utilize the vagrant template
cp $templates/style_vagrant/template_vagrant.html .
# Customize the template
doconce replace LogoWord 'DiffEq' template_vagrant.html
doconce replace withSubWord '101' template_vagrant.html
doconce replace '<a href="">GO TO 1</a>' '<a href="http://wikipedia.org">Wikipedia</a>' template_vagrant.html
doconce replace '<a href="">GO TO 2</a>' '<a href="http://wolframalpha.com">WolframAlpha</a>' template_vagrant.html
doconce replace 'Here goes a footer, if desired, maybe with a Copyright &copy;' '&copy; 2013' template_vagrant.html

doconce format html mydoc.do.txt --html_style=bootstrap --html_template=template_vagrant.html
pygmentize -f html -O full,style=emacs -o mydoc_vagrant_pygmentized.html -l html mydoc.html
cp mydoc.html $pub/mydoc_vagrant.html
cp -r style_vagrant mydoc_vagrant_pygmentized.html $pub/

# Report about the technology
# (must use --no_abort because of demo code with ref/label error message)
doconce format html wrapper_tech --html_style=bootswatch_readable --html_code_style=inherit --no_abort
cp wrapper_tech.html $pub/index.html
