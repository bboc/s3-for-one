make clean
make setup
make epub
cp tmp/s3-for-one.epub .
make ebook
cp tmp/s3-for-one.pdf .
make site