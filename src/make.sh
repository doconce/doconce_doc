#!/bin/sh -x
#set -x
#export PS4='+ l.${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
#sh -x ./clean.sh

PWD_orig="$PWD"

folders="manual tutorial devel quickref slides quiz locale latexcode api-source  edit trouble bootstrap design ipynb pyopt_pysc pgf_tikz admon book/repo/doc/src blog mathjax "


for folder in $folders; do
	echo "cd $folder"
	cd "$folder"
	bash make.sh
	if [ $? -ne 0 ]; then
		echo "unsuccessful command bash make in $folder"
		echo "abort!"
		cd $PWD_orig
		exit 1
		cd $PWD_orig
	fi
	cd $PWD_orig
done

echo "To remove untracked files run:"
echo "git clean -f -d"