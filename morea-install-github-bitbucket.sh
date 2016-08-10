#!/bin/bash

if [ $# != 4 ]; then
    echo "morea-install <bitbucket account> <bitbucket repo> <github account> <github repo>"
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


echo "Creating master/ directory with master branch (BITBUCKET)"
( set -x ; mkdir master; cd master; git init; git remote add origin https://$1@bitbucket.org/$1/$2.git; cd ..)

echo "Adding a remote called 'core' connected to morea-framework/core (this can fail if already set)"
(set x; cd ./master; git remote add core https://github.com/morea-framework/core.git)

echo "Fetching core"
( set -x ; cd ./master ; git fetch core)

echo "Merging core into master"
( set -x ; cd ./master ; git merge -m "merging core into master" core/master )

echo ""
echo "Creating gh-pages/ directory with gh-pages branch (GITHUB)"
( set -x ; git clone git@github.com:$3/$4.git gh-pages; cd gh-pages; git checkout gh-pages; git branch -u origin/gh-pages; cd ..)



echo ""
echo "master/ and gh-pages/ directories created."
echo "Now you can do a morea-merge-upstream.sh to get the core."


