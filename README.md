# Video-reducer

Script to reduce video size (recursively), with ffmpeg.
You can specify scaling (default: 1920x1808) and deactivate it if needed.

## Requirements

* ffmpeg (use snap version or compiled with x265)
* find (should be installed)

## Use

    ./scripts/video-reducer.sh /path/to/files

The script will search **recursively** into the `/path/to/files` for videos with format written into the script.
**After convertion, originales videos are deleted.**

### Change scaling

To change scaling, export the variable name `SCALE` to the desired value (example: `export SCALE=1920:1080`).

### Change format

To change format detected, change the array named `FORMATS` at the beginning of the script with your formats.

To change the final format, change the variable named `FINAL_FORMAT` at the beginning of the script with the format desired.

### Change speed

You can change speed by changing the variable `SPEED`. Faster = less compression.

Possible values: ultrafast,superfast, veryfast, faster, fast, medium, slow, slower, veryslow.

## Disclaimer

I use this script for my own files. I DO NOT guarantee the desired operation to be successful. Try this script at your own risk.

## Links

* [ffmpeg (H.265)](https://trac.ffmpeg.org/wiki/Encode/H.265)
