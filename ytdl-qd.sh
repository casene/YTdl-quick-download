#!/usr/bin/env sh

# Author: Casene
# Date: 01 Aug 2021

#### ---------------####

# script variables (Change this to your prefered location)
downloadpath=/tmp

# set error and exit traps
set -eE
trap 'find $downloadpath -user "$USER" -exec rm -rf "{}" \; && echo Fatal Error - Something has gone wrong, cleanup attempted.' ERR
trap 'rm -rf $downloadpath/meta' EXIT

# set OS environment
OS=$(uname)

# sanity check
if [ ! $(command -v jq) ]
    then
        case $OS in
            Darwin )
                osascript -e 'display notification "Jq is not installed" with title "Error 404"'
                exit 1
                ;;
            Linux )
                echo "JQ is not installed, exiting with status 1"
                exit 1
                ;;
        esac
fi

if [ ! $(command -v youtube-dl) ]
    then
        case $OS in
            Darwin )
                osascript -e 'display notification "Youtube-dl is not installed" with title "Error 404"'
                exit 1
                ;;
            Linux )
                echo "Youtube-dl is not installed, exiting with status 1"
                exit 1
                ;;
        esac
fi

## if you are here - checks returned okay
## script starts here


# ytdl command arguments (add,remove or modify to your liking)
# the whole command is redirected to stdout to a file named meta in /tmp
if [ $OS = "Darwin" ]
    then
        logpath=("~/Library/Logs/youtube-dl-downloads.log")
elif [ $OS = "Linux" ]
    then
        logpath=("~/youtube-dl-downloads.log")
fi

youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' \
-o "$downloadpath/%(title)s" \
--restrict-filenames \
--write-sub \
--merge-output-format 'mkv' \
--write-info-json \
--write-description \
--print-json \
--download-archive \
${logpath[@]} \
"$1" > "$downloadpath/meta"


# check ytdl exit status. if 0 then execute if block else exit
# with error 2
if [ $? -eq 0 ]
    then
        title=$(basename $(jq -r '._filename' $downloadpath/meta))

        newtitle=$(echo $title | Sed -E \
        -e 's/_s_/s_/g' \
        -e 's/_t_/t_/g' \
        -e 's/^[^[:alnum:]]+//' \
        -e 's/[^[:alnum:]]$//' \
        -e 's/[^[:alnum:]]+/-/g')

        newtitle=$(echo $newtitle | tr '[:upper:]' '[:lower:]')
    else
        case $OS in
            Darwin )
                osascript -e 'display notification "Ytdl exited with errors, check /tmp dir for downloaded files" with title "Fatal Error"'
                exit 1
                ;;
            Linux )
                echo "Ytdl exited with errors, check /tmp dir for downloaded files"
                exit 1
                ;;
        esac
fi


# create yt file directory
mkdir $downloadpath/$newtitle



# loop through files in /tmp and move them to dir if
#they match the regex $title
for file in $(ls $downloadpath/)
do
if [[ $file =~ $title ]]
then
    mv "$downloadpath/$file" "$downloadpath/$newtitle/$newtitle.${file##*.}"
fi
done


# cleanup
rm $downloadpath/meta

# There should now be a directory with the name of your video
# in the /tmp directory with the video, description, subs(if available)
# and json info file.