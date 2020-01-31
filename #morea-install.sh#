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


echo "Creating master/ directory with master branch"
( set -x ; git clone git@github.com:$1/$2.git master; cd master; git checkout master; cd ..)

echo ""
echo "Creating gh-pages/ directory with gh-pages branch"
( set -x ; git clone git@github.com:$1/$2.git gh-pages; cd gh-pages; git checkout gh-pages; git branch -u origin/gh-pages; cd ..)

echo ""
echo "master/ and gh-pages/ directories created."


