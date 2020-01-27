# set filename and add current date to output-files
NAME=s3-for-one
LOC=src/localization.po
PRJ=project.yaml
MKTPL=mdslides template

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
	$(MKTPL) src/templates/epub/metadata.yaml tmp/epub/metadata.yaml $(LOC) $(PRJ)
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
	
	$(MKTPL) src/templates/tex/ebook.tex tmp/tex/ebook.tex $(LOC) $(PRJ)
	cp src/templates/tex/ebook-style.sty tmp/tex/

	# render MMD to latex (output is included in master.tex)
	multimarkdown --to=latex --output=tmp/tex/compiled.tex src/templates/tex/master-tex.md
	# render to pdf
	cd tmp/tex; latexmk -pdf -xelatex -silent ebook.tex 
	# copy pdf to output folder
	cp tmp/tex/ebook.pdf tmp/$(NAME).pdf
	# clean up latex artefacts
	cd tmp/tex; latexmk -C


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
	cp src/s3-for-one.md tmp/web/s3-for-one.md
	$(MKTPL) src/templates/web/downloads.md tmp/web/downloads.md $(LOC) $(PRJ)
	$(MKTPL) src/templates/web/master-html.md tmp/web/master-html.md $(LOC) $(PRJ)

	# Render index.html and downloads.html
	multimarkdown --to=html --output=tmp/web/index.html tmp/web/master-html.md
	multimarkdown --to=html --output=tmp/web/downloads.html tmp/web/downloads.md

	rm tmp/web/downloads.md
	rm tmp/web/master-html.md
	rm tmp/web/s3-for-one.md

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
