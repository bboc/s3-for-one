# set filename and add current date to output-files
NAME=s3-for-one


make epub:
	# Render EPUB
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


make clean:
	# take no risk here!
	-rm -r tmp

make setup:
	echo "this might produce error output if directories already exist"
	-mkdir -p tmp
	-mkdir -p tmp/ebook
	-mkdir -p tmp/epub