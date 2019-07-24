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

parseInputArguments $arg1_path_to_media_files
switchPath $media_path
