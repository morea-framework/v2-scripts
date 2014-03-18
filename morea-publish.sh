#!/bin/bash

if [ ! -d "./master" ]; then
  echo "master/ directory does not exist.  Exiting..."
  exit 1
fi

if [ ! -d "./gh-pages" ]; then
  echo "gh-pages/ directory does not exist.  Exiting..."
  exit 1
fi

if [ $# != 1 ]; then
    echo "morea-publish <git commit message>"
    exit 1
fi

echo "Generating HTML site into gh-pages directory"
( set -x ; jekyll build --source ./master/src --destination ./gh-pages)

echo "Committing the gh-pages branch."
( set -x ; cd ./gh-pages ; git add . ; git commit -a -m "$1" ; git push origin gh-pages ) 

if [ $? -eq 0 ] ; then
    echo "Commit of gh-pages branch failed. Exiting..."
    exit 1
fi

echo "Committing the master branch"
( set -x ; cd ./master ; git add . ; git commit -a -m "$1" ; git push origin master ) 

