#!/bin/bash

if [ ! -d "./master" ]; then
  echo "master/ directory does not exist.  Exiting..."
  exit 1
fi

DIR="$( cd "$( dirname "$0" )" && pwd )"

set -x
jekyll serve --source "$DIR/master/src" --destination "$DIR/master/src/_site" --baseurl "" --watch
