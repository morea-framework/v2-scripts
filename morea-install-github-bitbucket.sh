#!/bin/bash

if [ $# != 4 ]; then
    echo "morea-install-github-bitbucket.sh <bitbucket account> <bitbucket repo> <github account> <github repo>"
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

BBUSER=$1
BBREPO=$2
GHUSER=$3
GHREPO=$4

#
# Check non-existence of repositories on BB and GH
#
# Check non-existence of repository on BB
git ls-remote git@bitbucket.org:$BBUSER/$BBREPO.git 2>&1 > /dev/null 
if [ $? == 0 ]; then
    echo "Repository $BBREPO already exists on bitbucket"
    exit 1
fi

# Check non-existence of repository on BB
git ls-remote git@github.com:$GHUSER/$GHREPO.git 2>&1 > /dev/null 
if [ $? == 0 ]; then
    echo "Repository $GHREPO already exists on github"
    exit 1
fi

#
# All good
# 

# Create repository on bitbucket
echo "Setting up repository on bitbucket"
echo
echo -n "Bitbucket password for $BBUSER: "
# read -s PASSWORD
# echo
#curl --user $BBUSER:$PASSWORD https://api.bitbucket.org/1.0/repositories/ --data name=$BBREPO > /dev/null
curl -s -u $BBUSER https://api.bitbucket.org/1.0/repositories/ --data name=$BBREPO 2>&1 > /dev/null
mkdir master
cd master
git init
touch README.md
git add README.md
git commit -m "First commit"
git remote add origin git@bitbucket.org:$BBUSER/$BBREPO.git
git push -u origin master
cd ..

# Create repository on github
echo "Setting up repository on github"
echo
echo -n "Github password for $BBUSER: "
curl -s -u $GHUSER https://api.github.com/user/repos -d "{\"name\":\"$GHREPO\"}" 2>&1 > /dev/null
mkdir gh-pages
cd gh-pages
git init
touch README.md
git add README.md
git commit -m "First commit"
git remote add origin git@github.com:$GHUSER/$GHREPO.git
git push -u origin master
git checkout -b gh-pages
git push origin gh-pages
cd ..

# Pull the morea framework into master
cd master
git remote add core https://github.com/morea-framework/core.git
git fetch core
git merge -m "merging core into master" core/master
git push -u origin --all
cd ..

git clone https://github.com/morea-framework/scripts
mv scripts/morea-* .
chmod +x morea-*
rm -rf scripts


