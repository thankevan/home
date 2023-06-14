#!/bin/bash

filename="$1"

if [ "$filename" = "" ]; then
  echo "Please specify a filename"
  exit
fi

if ! [ -e "$filename" ]; then
  echo "No file $filename"
  exit
fi

mp3file="${filename%.*}.mp3"

ffmpeg -i "$filename" -acodec libmp3lame -ar 22050 "$mp3file"
