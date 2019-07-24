#!/bin/sh

# Input arguments
arg1_path_to_media_files=$1

# Global variables
media_path=

parseInputArguments () {
    local path=$1
    if [ -z "$path" ]
    then
        echo "usage: script [path-to-media-files]

        -- Updates the DateTimeOriginal meta data of video files (*.mp4 *.m4v *.mov)
        -- Updates the DateTimeOriginal meta data of signal and whatsapp files
        -- Renames all files based on their DateTimeOriginal meta data
        -- Moves all files without DateTimeOriginal meta data into subfolder"
        exit
    fi
    
    if [ -z "$path" ]
    then
        echo "Please specifiy [path-to-media-files]"
        exit
    fi

    if [ ! -d "$path" ]
    then
        echo "Path does not exist: $path"
        exit
    else 
        echo "Using path-to-media-files: $path"
        media_path="$path"
    fi
}

switchPath () {
    local path=$1

    script_execution_directory=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    echo "Script execution directory: $script_execution_directory"

    echo "Switching to path-to-media-files: $path"
    cd $path
}

updateDateTimeOriginalForVideoMedia () {
    echo ""
    echo "~~ Update DateTimeOriginal for Video Media"

    for filename in *.mp4 *.m4v *.mov; do
        # Skip if file does not exist
        [ -e "$filename" ] || continue

        metadata_DateTimeOriginal=$(exiftool '-DateTimeOriginal' '-s' '-s' '-s' "$filename")

        # Skip file if DateTimeOriginal is already present
        [ -z "$metadata_DateTimeOriginal" ] || continue

	    echo "Working on $filename"

        metadata_CreateDate=$(exiftool '-CreateDate' '-s' '-s' '-s' "$filename")
        if [ -n "$metadata_CreateDate" ]
        then
             exiftool -q -overwrite_original -if '$CreateDate' '-CreateDate>DateTimeOriginal' "$filename"
             continue
        fi

        metadata_ContentCreateDate$(exiftool '-ContentCreateDate' '-s' '-s' '-s' "$filename")
        if [ -n "$metadata_ContentCreateDate" ]
        then
             exiftool -q -overwrite_original -if '$ContentCreateDate' '-ContentCreateDate>DateTimeOriginal' "$filename"
             continue
        fi
    done
}

parseInputArguments $arg1_path_to_media_files
switchPath $media_path

updateDateTimeOriginalForVideoMedia
