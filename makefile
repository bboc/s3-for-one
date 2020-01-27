# set filename and add current date to output-files
NAME=s3-for-one
OUTPUT=../$NAME--$(date +%Y-%m-%d)

make epub:
	# ---- Render EPUB ----
	ifneq ("$(wildcard $(TMPFOLDER)/epub/img)","")
		# take no risk here!
		rm -r tmp/epub/img
	endif 


	# render markdown to HTML
	multimarkdown --to=html --output=$NAME.html master-epub.md
	# use pandoc to create epub file
	pandoc --epub-stylesheet=buttondown.css --epub-metadata=epub-metadata.xml --epub-cover-image=img/book-cover.png  -S -o $OUTPUT.epub $NAME.html

ebook:
	# ---- Render PDF ----
	# render MMD to latex (output is included in master.tex)
	multimarkdown --to=latex --output=compiled.tex master-tex.md
	# render to pdf
	latexmk -pdf -silent master.tex 
	# copy pdf to output folder
	cp master.pdf $OUTPUT.pdf
	# clean up latex artefacts
	latexmk -c master.tex 


make site:
	# ---- Create website ----
	# Render index.html and downloads.html
	multimarkdown --to=html --output=website/index.html master-html.md
	multimarkdown --to=html --output=website/downloads.html downloads.md
	# provide pdf and png for website
	mv master.pdf website/$NAME.pdf
	cp $OUTPUT.epub website/$NAME.epub
	# copy images
	rm website/img/*
	cp img/* website/img/
	# copy additional files
	cp bernhard-bockelbrink.png website/
	cp styles.css website/

make clean:
	# take no risk here!
	-rm -r tmp

make setup:
	echo "this might produce error output if directories already exist"
	-mkdir -p tmp
	-mkdir -p tmp/ebook
	-mkdir -p tmp/epub
