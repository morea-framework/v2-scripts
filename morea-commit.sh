#!/bin/bash

if [ ! -d "./master" ]; then
  echo "master/ directory does not exist.  Exiting..."
  exit 1
fi

if [ $# != 1 ]; then
    echo "morea-commit <git commit message>"
    exit 1
fi

echo "Committing the master branch"
( set -x ; cd ./master ; git add . ; git commit -a -m "$1" ; git push origin master ) 

