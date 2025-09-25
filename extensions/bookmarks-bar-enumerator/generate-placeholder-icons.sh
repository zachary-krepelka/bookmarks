#!/usr/bin/env bash

# FILENAME: generate-placeholder-icons.sh
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, September 24th, 2025

mkdir -p images
for px in 16 32 48 128
do convert -size ${px}x$px xc:lime images/icon-$px.png
done
