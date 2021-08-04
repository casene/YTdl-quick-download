## YTdl-quick-download

#### Quick Description:

A pretty simple bash script that downloads a Youtube video, the description file, the JSON info file and subs if available. The resulting video and audio files are muxed to an mkv file. The file names are then sanitized and moved to a newly created directory with the same name as the downloaded video.

#### Usage:

Call the script with a URL as an argument.

```bash
./ytdl-qd "URL to your video"
```

That's pretty much it. You should now have a new directory in your `/tmp` directory with the downloaded files.

#### Prerequisites:

The script has the following prerequisites:

- Youtube-dl

- JQ
  
  The script checks for these prerequisites before executing anything. It will return an error message and exit with exit code 2 if the prerequisites are not found. 

#### Testing:

I have tried to make the script runnable on both OSX and various Linux flavours. Testing has been done on MacOS Catalina and Ubuntu Server 16.04.
