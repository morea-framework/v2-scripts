#!/bin/bash

if [ ! -d "./master" ]; then
  echo "master/ directory does not exist.  Exiting..."
  exit 1
fi

if [ ! -d "./gh-pages" ]; then
  echo "gh-pages/ directory does not exist.  Exiting..."
  exit 1
fi

echo "Fetching upstream (typically basic-template)"
( set -x ; cd ./master ; git fetch upstream)

if [ $? -eq 0 ] ; then
    echo "Upstream fetch failed (Maybe nothing to fetch?). Exiting."
    exit 1
fi


echo "Merging upstream into master"
( set -x ; cd ./master ; git merge upstream/master ) 

if [ $? -eq 0 ] ; then
    echo "Upstream merge failed. Exiting."
    exit 1
fi

