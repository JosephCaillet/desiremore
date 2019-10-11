# desirmore
Batch converter of audio files in alac format, using ffmpeg powaaa!

Requires Ruby and ffmpeg to be installed:

`$ sudo apt-get install ruby ffmpeg`

**Project in early development phase, a more detailed readme and more file format support will come later (hopefully...).**

Planned usage:

````
$ desirmore -h
Usage: desirmore [options]
    -i, --input PATTERN              Files to convert pattern/glob (default '.')
    -b, --base BASE                  Beginning part of input path to remove in output file path (default '')
    -o, --output OUTPUT              Converted files folder (default 'out')
    -p, --preview                    Preview mode (default 'false')
    -h, --help                       Dispaly this help message
````

If in your path:

`$ desirmore -i 'music/**/*.flac' -b 'music/' -p`

Otherwise:

`$ ruby desirmore.rb -i 'music/**/*.flac' -b 'music/' -p`

## About
boris is made by Joseph Caillet and is released under GPL-3.0.<br>
View source code, report bug, contribute here: https://github.com/JosephCaillet/desirmore.