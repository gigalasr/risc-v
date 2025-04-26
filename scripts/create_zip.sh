#!/bin/bash

if [ -z "$1" ]
  then
    echo "Please provide name"
    exit 1
fi

NAME=pfrenger_lars_$1.zip
NAME_DIR=pfrenger_lars_$1

mkdir -p submissions

git add .
zip -r submissions/$NAME $(git diff --name-only --cached) $(tools/vhdlmake/build/vhdlmake subset) tools/vhdlmake/build/vhdlmake

if [ "$2" = "check" ]; then
    cd submissions
    unzip $NAME -d $NAME_DIR
    cd $NAME_DIR
    ./tools/vhdlmake/build/vhdlmake build
    cd ..
    rm -rf $NAME_DIR
    cd ..
fi
