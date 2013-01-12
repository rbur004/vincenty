#!/bin/sh
#create doc
git log --pretty=format:"%an%x09%ad%x0a%x09%s" > History.txt

/usr/local/bin/rake docs
cp -r doc/* ../doc
rm -rf doc
( cd ../doc; git add . ; git commit -a --allow-empty-message -m ""; git push origin gh-pages )

