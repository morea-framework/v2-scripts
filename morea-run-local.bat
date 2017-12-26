@echo off
if not exist "%cd%\master\" GOTO master

jekyll serve --source "%cd%\master\src" --destination "%cd%\master\src\_site" --baseurl "" --watch

GOTO end
:master
echo "master/ directory does not exist.  Exiting..."
GOTO end
:end
