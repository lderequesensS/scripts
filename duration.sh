#!/bin/bash

shopt -s extglob

total_hours=0
total_minutes=0
total_seconds=0

for file in *{.mp4,.m4a}; do
	duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 -sexagesimal $file 2>/dev/null)
	if [ $? -ne 0 ]; then
		continue
	fi
	IFS=':' read -r hours minutes seconds <<< $duration

	((total_hours+=hours))
	((total_minutes+=minutes))
	seconds=$(bc <<< "$seconds / 1")
	((total_seconds+=seconds))
done

((total_minutes+=total_seconds / 60))
((total_seconds=total_seconds % 60))
((total_hours+=total_minutes / 60))
((total_minutes=total_minutes % 60))

echo "Time used: ${total_hours}:${total_minutes}:${total_seconds}"
