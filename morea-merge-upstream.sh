#!/bin/bash

if [ ! -d "./master" ]; then
  echo "master/ directory does not exist.  Exiting..."
  exit 1
fi

if [ ! -d "./gh-pages" ]; then
  echo "gh-pages/ directory does not exist.  Exiting..."
  exit 1
fi

echo "Setting the remote to morea-framework/basic-template (this can fail if already set)"
(set x; cd ./master; git remote add upstream https://github.com/morea-framework/basic-template.git)

echo "Here are the current upstream repos:"
(set x; cd ./master; git remote -v)

echo "Fetching upstream basic-template"
( set -x ; cd ./master ; git fetch upstream)

echo "Merging upstream into master"
( set -x ; cd ./master ; git merge upstream/master ) 

