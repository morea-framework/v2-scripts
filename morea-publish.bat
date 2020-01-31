@echo off
set argC=0
for %%x in (%*) do Set /A argC+=1
IF "%argC%" NEQ "1" GOTO No-args

if not exist "%cd%\master\" GOTO master
if not exist "%cd%\gh-pages\" GOTO gh-pages

echo "Sync gh-pages directory with GitHub repo before updating."
cd gh-pages
git pull
cd ..

call jekyll build --source %cd%\master\src --destination %cd%\gh-pages

echo "Committing the gh-pages branch."
cd gh-pages
git add --all .
git commit -a -m "%1"
git push origin gh-pages
cd ..
echo "Committing the master branch"
cd master
git add --all .
git commit -a -m "%1"
git push origin master
cd ..

GOTO end
:No-args
echo "morea-publish <git commit message>"
GOTO end
:master
echo "master/ directory does not exist.  Exiting..."
GOTO end
:gh-pages
echo "gh-pages/ directory does not exist.  Exiting..."
:end
