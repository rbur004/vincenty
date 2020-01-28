#!/bin/sh
git log --pretty=format:"%an%x09%ad%x0a%x09%s" > History.txt
gem build vincenty.gemspec
