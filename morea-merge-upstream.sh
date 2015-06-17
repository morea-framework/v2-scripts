#!/bin/bash

if [ ! -d "./master" ]; then
  echo "master/ directory does not exist.  Exiting..."
  exit 1
fi

if [ ! -d "./gh-pages" ]; then
  echo "gh-pages/ directory does not exist.  Exiting..."
  exit 1
fi

echo "Adding a remote called core linked to morea-framework/core (this can fail if already set)"
(set x; cd ./master; git remote add core https://github.com/morea-framework/core.git)

echo "Here are the current upstream repos:"
(set x; cd ./master; git remote -v)

echo "Fetching upstream core"
( set -x ; cd ./master ; git fetch core)

echo "Merging core into master"
( set -x ; cd ./master ; git merge -m "Merging core into master" core/master ) 

