#!/bin/bash

# Prepare data
rm -rf ./tmp
cp -r ./videos ./tmp

# Test
./video-reducer.sh ./tmp
