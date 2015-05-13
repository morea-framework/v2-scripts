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

echo "Adding a remote called 'core' connected to morea-framework/core (this can fail if already set)"
(set x; cd ./master; git remote add core https://github.com/morea-framework/core.git)

echo "Here are the current upstream repos:"
(set x; cd ./master; git remote -v)

echo "Fetching core"
( set -x ; cd ./master ; git fetch core)

echo "Merging core into master"
( set -x ; cd ./master ; git merge -m "merging core into master" core/master ) 
