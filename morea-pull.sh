#!/bin/bash

if [ ! -d "./master" ]; then
  echo "master/ directory does not exist.  Exiting..."
  exit 1
fi

if [ ! -d "./gh-pages" ]; then
  echo "gh-pages/ directory does not exist.  Exiting..."
  exit 1
fi

echo "Pulling the gh-pages directory."
( set -x ; cd ./gh-pages ; git branch -u origin/gh-pages ; git pull ) 

echo "Pulling the master directory"
( set -x ; cd ./master ; git pull)

