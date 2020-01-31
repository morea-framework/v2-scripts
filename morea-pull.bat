@echo off
if not exist "%cd%\master\" GOTO master
if not exist "%cd%\gh-pages\" GOTO gh-pages

echo "Pulling the gh-pages directory."
cd gh-pages
git branch -u origin/gh-pages
git pull
cd ..
echo "Pulling the master directory"
cd master
git pull
cd ..

GOTO end
:master
echo "master/ directory does not exist.  Exiting..."
GOTO end
:gh-pages
echo "gh-pages/ directory does not exist.  Exiting..."
:end
