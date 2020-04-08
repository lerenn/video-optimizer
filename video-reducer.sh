#!/bin/bash

# Custom variables
SCALE="-vf \"scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2\""

# "Constant" variables
FORMATS=("3gp" "avi" "m4v" "mov" "mp4" "mpg" "mts" "ogm")
SPEED=veryslow
PATH_TO_FILES="$1"
FINAL_FORMAT="mkv"
FILES=()

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

# Check interrupt
trap interrupt INT

function interrupt {
        echo "Interrupted"
        rm -rf "$newfile"
        exit
}

# Check path to files
if [ "$1" == "" ]; then
  echo "No path to files was put as an argument"
  exit
fi

# Get files for specified format
for format in ${FORMATS[@]}; do
  while IFS= read -r -d $'\0'; do
      echo " - $REPLY"
      FILES+=("$REPLY")
  done < <(find "$PATH_TO_FILES" -iname "*.$format" -print0)
done

# Check if there is files
if [ ${#FILES[@]}  == 0 ]; then
  echo "No files found for given formats : ${FORMATS[@]}"
  exit
fi

# Check if scaling is activated
if [ "$SCALE" != "" ]; then
  echo "Scaling activated to $SCALE"
  SCALE="-vf scale=$SCALE"
fi

# display prompt before launching convertion
echo "${#FILES[@]} files will be converted."
read -p "Are you sure? [yN] " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo ""
  echo "Exiting..."
  exit 1
fi
echo "" # Skip a line

# Processing files
for file in "${FILES[@]}"; do
  # Get new file name
  newfile="${file%.*}.$FINAL_FORMAT"
  echo -e "$GREEN[$(date)] Processing '$file'... $NC"

  # Display frames numbers
  FRAMES_NB=$(ffprobe -select_streams v -show_streams "${file}" |& grep nb_frames)
  echo "Number of frames for this video: ${FRAMES_NB}"

  # Transform the file and remove old one if successful
  ffmpeg -loglevel warning \
    -v quiet -stats \
    -i "$file" \
    -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
    -c:v libx265 \
    -c:a libfdk_aac -b:a 128k \
    -preset $SPEED \
    "$newfile" &&  \
    rm "$file"
done

echo "All convertions are completed."
