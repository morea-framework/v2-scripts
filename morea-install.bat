@echo off
set argC=0
for %%x in (%*) do Set /A argC+=1

IF "%argC%" NEQ "2" GOTO No-args

if exist "%cd%\master\" GOTO master
if exist "%cd%\gh-pages\" GOTO gh-pages

git clone git@github.com:"%1"/"%2".git master
cd master
git checkout master
cd ..
git clone git@github.com:"%1"/"%2".git gh-pages
cd gh-pages
git checkout gh-pages
cd ..

GOTO end
:No-args
echo "morea-install <github account> <github repo>"
GOTO end
:master
echo "master/ directory already exists.  Exiting..."
GOTO end
:gh-pages
echo "gh-pages/ directory already exists.  Exiting..."
:end
