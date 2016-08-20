#!/bin/bash

# Variables
PATH_TO_FILES="$1"
FORMATS=("mov" "mp4" "avi" "mpg" "3gp" "mts")
FINAL_FORMAT="mkv"
FILES=()

# Check path to files
if [ "$1" == "" ]; then
  echo "No path to file was put as an argument"
  exit
fi

# Get files for specified format
for format in ${FORMATS[@]}; do
  for file in `find $PATH_TO_FILES -iname "*.$format"`; do
    FILES+=($file)
  done
done

# Check if there is files
if [ ${#FILES[@]}  == 0 ]; then
  echo "No files found for given formats : ${FORMATS[@]}"
  exit
fi

# Processing files
for file in ${FILES[@]}; do
  # Get new file name
  newfile="${file%.*}.FINAL_FORMAT"
  echo " > Processing '$file' to '$newfile'"
  # Transform the file and remove old one if successful
  ffmpeg -i $file -vcodec libx264 -crf 20 $newfile && rm $file
done
