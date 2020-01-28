#!/bin/sh
#create doc

bundle exec yard --markup markdown --protected

# ( cd ../doc; git add . ; git commit -a --allow-empty-message -m ""; git push origin gh-pages )
