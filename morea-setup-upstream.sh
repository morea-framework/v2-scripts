#!/bin/bash

if [ ! -d "./master" ]; then
  echo "master/ directory does not exist.  Exiting..."
  exit 1
fi

if [ ! -d "./gh-pages" ]; then
  echo "gh-pages/ directory does not exist.  Exiting..."
  exit 1
fi

echo "Setup upstream"
( set -x ; cd ./master ; git remote add upstream https://github.com/morea-framework/basic-template.git)

if [ $? -eq 0 ] ; then
    echo "git remote add failed. Exiting."
    exit 1
fi
