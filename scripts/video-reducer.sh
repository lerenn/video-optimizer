#!/bin/bash

# Constants
FORMATS=("3gp" "avi" "m4v" "mov" "mp4" "mpg" "mts" "ogm")
SPEED=veryslow
PATH_TO_FILES="$1"
FINAL_FORMAT="mkv"
FILES=()

# Export library path that could be missing
LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64 && export LD_LIBRARY_PATH

# Check ffmpeg binaries
if test -f "/snap/bin/ffmpeg"; then
	FFMPEG="/snap/bin/ffmpeg"
else 
	FFMPEG="ffmpeg"
fi

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

# Check if scaling is activated
if [ "$SCALE" != "" ]; then
  echo "Scaling activated to $SCALE"
  SCALE_ARG="-vf scale=$SCALE:force_original_aspect_ratio=decrease,pad=$SCALE:(ow-iw)/2:(oh-ih)/2"
  echo "$SCALE_ARG"
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

# display prompt before launching convertion
echo "${#FILES[@]} files will be converted."
if [ -z "$NO_INTERACTION_MODE" ]; then
  read -p "Are you sure? [yN] " -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Exiting..."
    exit 1
  fi
  echo "" # Skip a line
fi

# Processing files
for file in "${FILES[@]}"; do
  # Get new file name
  newfile="${file%.*}.$FINAL_FORMAT"
  echo -e "$GREEN[$(date)] Processing '$file'... $NC"

  # Display infos
  echo "# Extra informations"
  ffprobe -select_streams v -show_streams "${file}" |& grep nb_frames
  ffprobe -select_streams v -show_streams "${file}" |& grep "Duration:"
  echo "###"

  # Transform the file and remove old one if successful
  $FFMPEG -loglevel warning \
    -v quiet -stats \
    -i "$file" \
    $SCALE_ARG \
    -c:v libx265 \
    -c:a libfdk_aac -b:a 128k \
    -preset $SPEED \
    "$newfile" &&  \
    rm "$file"
done

echo "All convertions are completed."
