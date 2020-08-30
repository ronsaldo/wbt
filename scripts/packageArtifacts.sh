#!/usr/bin/env bash
set -ex

if test "$PLATFORM_NAME" = ""; then
    PLATFORM_NAME=`$(uname -s)`
fi

DIST=artifacts/dist/$PLATFORM_NAME

mkdir -p "$DIST"
cp -R pharo-vm pharo pharo-ui $DIST
cp -R Pharo*.sources wbt.* wbt wbt-ui $DIST
cp -R LICENSE README.md $DIST
