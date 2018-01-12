@echo off
set argC=0
for %%x in (%*) do Set /A argC+=1

IF "%argC%" NEQ "2" GOTO No-args

if exist "%cd%\master\" GOTO master
if exist "%cd%\gh-pages\" GOTO gh-pages

echo "Creating master/ directory with repo."
git clone git@github.com:"%1"/"%2".git master

echo "Creating orphan branch, empty gh-pages/ directory."
git clone git@github.com:"%1"/"%2".git gh-pages
if NOT exist "%cd%\gh-pages" GOTO gh-pages-fail
cd gh-pages
git checkout --orphan gh-pages
git rm -rf .
git branch -u origin/gh-pages
git branch --set-upstream-to=origin/gh-pages gh-pages
cd ..

echo "master/ and gh-pages/ directories created."

echo "Adding a remote called 'core' connected to morea-framework/core (this can fail if already set)"
cd master
git remote add core https://github.com/morea-framework/core.git

echo "Here are the current upstream repos:"
git remote -v

echo "Fetching core"
git fetch core

echo "Merging core into master"
git merge -m "merging core into master" core/master


GOTO end
:No-args
echo "morea-vanilla-install <github account> <github repo>"
GOTO end
:master
echo "master/ directory already exists.  Exiting..."
GOTO end
:gh-pages-fail
echo "gh-pages directory not created. Exiting..."
GOTO end
:gh-pages
echo "gh-pages/ directory already exists.  Exiting..."
:end
