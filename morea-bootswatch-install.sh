#!/bin/bash

# requires the core, bootswatch, and scripts repos to be checked out into same subdirectory.

if [ ! -d "../core" ]; then
  echo "../core subdirectory directory not found.  Exiting..."
  exit 1
fi

if [ ! -d "../bootswatch" ]; then
  echo "../bootswatch subdirectory not found.  Exiting..."
  exit 1
fi


echo "Installing cerulean"
( set -x ; cd ../bootswatch/ ; grunt swatch:cerulean ; cp cerulean/bootstrap.min.css ../core/src/css/themes/cerulean/ )

echo "Installing cerulean_brown"
( set -x ; cd ../bootswatch/ ; grunt swatch:cerulean_brown ; cp cerulean_brown/bootstrap.min.css ../core/src/css/themes/cerulean_brown/ )

echo "Installing cerulean_green"
( set -x ; cd ../bootswatch/ ; grunt swatch:cerulean_green ; cp cerulean_green/bootstrap.min.css ../core/src/css/themes/cerulean_green/ )

echo "Installing cerulean_purple"
( set -x ; cd ../bootswatch/ ; grunt swatch:cerulean_purple ; cp cerulean_purple/bootstrap.min.css ../core/src/css/themes/cerulean_purple/ )

echo "Installing cerulean_red"
( set -x ; cd ../bootswatch/ ; grunt swatch:cerulean_red ; cp cerulean_red/bootstrap.min.css ../core/src/css/themes/cerulean_red/ )

echo "Installing darkly"
( set -x ; cd ../bootswatch/ ; grunt swatch:darkly ; cp darkly/bootstrap.min.css ../core/src/css/themes/darkly/ )

echo "Installing flatly"
( set -x ; cd ../bootswatch/ ; grunt swatch:flatly ; cp flatly/bootstrap.min.css ../core/src/css/themes/flatly/ )

echo "Installing journal"
( set -x ; cd ../bootswatch/ ; grunt swatch:journal ; cp journal/bootstrap.min.css ../core/src/css/themes/journal/ )

echo "Installing lumen"
( set -x ; cd ../bootswatch/ ; grunt swatch:lumen ; cp lumen/bootstrap.min.css ../core/src/css/themes/lumen/ )

echo "Installing paper"
( set -x ; cd ../bootswatch/ ; grunt swatch:paper ; cp paper/bootstrap.min.css ../core/src/css/themes/paper/ )

echo "Installing readable"
( set -x ; cd ../bootswatch/ ; grunt swatch:readable ; cp readable/bootstrap.min.css ../core/src/css/themes/readable/ )

echo "Installing sandstone"
( set -x ; cd ../bootswatch/ ; grunt swatch:sandstone ; cp sandstone/bootstrap.min.css ../core/src/css/themes/sandstone/ )

echo "Installing simplex"
( set -x ; cd ../bootswatch/ ; grunt swatch:simplex ; cp simplex/bootstrap.min.css ../core/src/css/themes/simplex/ )

echo "Installing slate"
( set -x ; cd ../bootswatch/ ; grunt swatch:slate ; cp slate/bootstrap.min.css ../core/src/css/themes/slate/ )

echo "Installing spacelab"
( set -x ; cd ../bootswatch/ ; grunt swatch:spacelab ; cp spacelab/bootstrap.min.css ../core/src/css/themes/spacelab/ )

echo "Installing superhero"
( set -x ; cd ../bootswatch/ ; grunt swatch:superhero ; cp superhero/bootstrap.min.css ../core/src/css/themes/superhero/ )

echo "Installing united"
( set -x ; cd ../bootswatch/ ; grunt swatch:united ; cp united/bootstrap.min.css ../core/src/css/themes/united/ )

echo "Installing yeti"
( set -x ; cd ../bootswatch/ ; grunt swatch:yeti ; cp yeti/bootstrap.min.css ../core/src/css/themes/yeti/ )

echo ""



