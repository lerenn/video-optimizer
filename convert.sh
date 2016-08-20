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
  while IFS= read -r -d $'\0'; do
      echo " - $REPLY"
      FILES+=("$REPLY")
  done < <(find $PATH_TO_FILES -iname "*.$format" -print0)
done

# Check if there is files
if [ ${#FILES[@]}  == 0 ]; then
  echo "No files found for given formats : ${FORMATS[@]}"
  exit
fi

# display prompt before launching convertion
echo "Those file will be converted."
read -p "Are you sure? [yN] " -n 1 -r
echo # Move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "Exiting..."
  exit 1
fi

# Processing files
for file in "${FILES[@]}"; do
  # Get new file name
  newfile="${file%.*}.$FINAL_FORMAT"
  echo -n "> Processing '$file' to '$newfile'... "
  # Transform the file and remove old one if successful
  ffmpeg -loglevel panic -i "$file" -vcodec libx264 -crf 20 "$newfile" && rm "$file"
  echo "Done."
done

echo "All convertions are completed."
