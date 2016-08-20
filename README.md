# Video-reducer
Script to reduce video size (recursively), with ffmpeg.

## Requirements

* ffmpeg
* find (should be installed)

## Use

    ./convert.sh /path/to/files

The script will search **recursively** into the `/path/to/files` for videos with format written into the script.
**After convertion, originales videos are deleted.**

### Change format

To change format detected, change the array named `FORMATS` at the beginning of the script with your formats.

To change the final format, change the variable named `FINAL_FORMAT` at the beginning of the script with the format desired.

## Disclaimer

I use this script for my own files. I DO NOT guarantee the desired operation to be successful. Try this script at your own risk.
