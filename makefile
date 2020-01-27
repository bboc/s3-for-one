# set filename and add current date to output-files
NAME=s3-for-one


make epub:
	# ---- Render EPUB ----
ifneq ("$(wildcard tmp/epub/img)","")
	# take no risk here!
	rm -r tmp/epub/img
endif
	cp -r src/img tmp/epub/

	# copy necessary files
	cp src/templates/epub/master-epub.md tmp/epub/
	cp src/templates/epub/buttondown.css tmp/epub/
	cp src/templates/epub/metadata.yaml tmp/epub/
	cp src/s3-for-one.md tmp/epub/

	# render markdown to HTML
	cd tmp/epub; multimarkdown --to=html --output=$(NAME).html master-epub.md
	# use pandoc to create epub file
	cd tmp/epub; pandoc --metadata-file=metadata.yaml  -s -o ../$(NAME).epub $(NAME).html


ebook:
	# ---- Render PDF ----

	# remove old images
ifneq ("$(wildcard tmp/tex/img)","")
	# take no risk here!
	rm -r tmp/tex/img
endif
	# copy images and styles
	cp -r src/img tmp/tex/
	cp src/templates/tex/master.tex tmp/tex/
	cp src/templates/tex/cvstyle.sty tmp/tex/

	# render MMD to latex (output is included in master.tex)
	multimarkdown --to=latex --output=tmp/tex/compiled.tex src/templates/tex/master-tex.md
	# render to pdf
	cd tmp/tex; latexmk -pdf -silent master.tex 
	# copy pdf to output folder
	cp tmp/tex/master.pdf tmp/$(NAME).pdf
	# clean up latex artefacts
	cd tmp/tex; latexmk -c master.tex 


make site:
	# ---- Create website ----
	# remove old images
ifneq ("$(wildcard tmp/web/img)","")
	# take no risk here!
	rm -r tmp/web/img
endif
	# copy images and styles
	cp -r src/img tmp/web/
	cp src/templates/web/styles.css tmp/web/

	# Render index.html and downloads.html
	multimarkdown --to=html --output=tmp/web/index.html src/templates/web/master-html.md
	multimarkdown --to=html --output=tmp/web/downloads.html src/downloads.md
	# provide pdf and epub for website
	cp $(NAME).epub tmp/web/$(NAME).epub
	cp $(NAME).pdf tmp/web/$(NAME).pdf

make clean:
	# take no risk here!
	-rm -r tmp

make setup:
	echo "this might produce error output if directories already exist"
	-mkdir -p tmp
	-mkdir -p tmp/epub
	-mkdir -p tmp/tex
	-mkdir -p tmp/web
