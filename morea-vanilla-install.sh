#!/bin/bash

if [ $# != 2 ]; then
    echo "morea-vanilla-install <github account> <github repo>"
    exit 1
fi

if [ -d "./master" ]; then
  echo "master/ directory already exists.  Exiting..."
  exit 1
fi

if [ -d "./gh-pages" ]; then
  echo "gh-pages/ directory already exists.  Exiting..."
  exit 1
fi


echo "Creating master/ directory with repo."
( set -x ; git clone git@github.com:$1/$2.git master)

echo ""
echo "Creating orphan branch, empty gh-pages/ directory."
( set -x ; git clone git@github.com:$1/$2.git gh-pages)

if [ -d "./gh-pages" ]; then
  ( set -x ; cd gh-pages; git checkout --orphan gh-pages; git rm -rf . )
else
  echo "gh-pages directory not created. Exiting..."
  exit 1
fi

echo ""
echo "master/ and gh-pages/ directories created."

echo "Setting the remote to morea-framework/basic-template (this can fail if already set)"
(set x; cd ./master; git remote add upstream https://github.com/morea-framework/basic-template.git)

echo "Here are the current upstream repos:"
(set x; cd ./master; git remote -v)

echo "Fetching upstream basic-template"
( set -x ; cd ./master ; git fetch upstream)

echo "Merging upstream into master"
( set -x ; cd ./master ; git merge upstream/master ) 

echo "Fix the README merge conflict by adding it and committing it"
#( set -x ; cd ./master ; git add README.md ; git commit -a -m "Adding README back into tree." ) 
