# desiremore
Batch recursive converter of audio files, using ffmpeg powaaa!

desiremore development started when I needed a tool to convert audio files:
1. In batch (recursive conversion of every audio files inside a directory)
2. With preservation of the folder strucutre
3. With preservation of tags and covers
4. Without specifying a global conversion profile (use input file by input file caracteristics instead)

It turns out some software already existed to fulfill the first three requirements, but not n°4. However, ffmpeg cli tool magnificently support number requirements n°4, but not 1 to 3...

Couldn't we write something above it then? Well, desiremore is just that: a wrapper above ffmpeg to convert audio file in batch ! 😎

**desiremore is in an early development phase (eg audio destination format is hardcoded), a more detailed readme and more file format support will come later.**

desriremore is made by Joseph Caillet and is released under GPL-3.0.<br>
View source code, report bug, contribute here: https://github.com/JosephCaillet/desiremore.

## Configuration
Requires Ruby and ffmpeg to be installed:

`$ sudo apt-get install ruby ffmpeg`


## Usage
````
$ desiremore -h
Usage: desiremore [options]
    -i, --input PATTERN              Files to convert pattern/glob (default '.')
    -b, --base BASE                  Beginning part of input path to remove in output file path (default '')
    -o, --output OUTPUT              Converted files folder (default 'out')
    -p, --preview                    Preview mode (default 'false')
    -h, --help                       Dispaly this help message
````

If in your path:

`$ desiremore -i 'music/**/*.flac' -b 'music/' -p`

Otherwise:

`$ ruby desiremore.rb -i 'music/**/*.flac' -b 'music/' -p`