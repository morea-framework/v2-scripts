#!/bin/bash

if [ $# != 2 ]; then
    echo "morea-install <github account> <github repo>"
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


