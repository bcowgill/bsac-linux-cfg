#!/bin/bash
# take a photo with the web camera.
# params -- prefix only saves to default dir with datestamp added .jpg
# dir - use dire but generate file name
# dir+file without extension - add datestamp to file name .jpg
# full path - just save file, change to --png if needed.
# second paramter png to change file type.
# prompt countdown or skip, display or skip.

DIR=~/d/Pics/webcam
FILE=$DIR/webcam-`datestampfn.sh`.jpg
mkdir -p $DIR
echo "Smile and look at the camera!"
# play countdown sound...
sleep 1
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
echo "Click!"
fswebcam --no-banner "$FILE"
# play shutter click sound.
ls -al "$FILE"
identify "$FILE"
display "$FILE"
exit $?
FSWEBCAM(1)                                                            User Commands                                                            FSWEBCAM(1)



NAME
       fswebcam - Small and simple webcam for *nix.

SYNOPSIS
       fswebcam [<options>] <filename> [[<options>] <filename> ... ]

DESCRIPTION
       fswebcam  is a small and simple webcam app for *nix. It can capture images from a number of different sources and perform simple manipulation on the
       captured image. The image can be saved as one or more PNG or JPEG files.

       The PNG or JPEG image can be sent to stdio using the filename "-". The output filename is formatted by strftime.


CONFIGURATION
   Configuration File
       Config files use the long version of options without the "--" prefix. Comments start with a # symbol at the beginning of the line.


   General Options
       -?, --help
              Show a usage summary.


       -c, --config
              Load options from a file. You can load more than one config file, and can mix them with command-line arguments.

              Note: This option can not be used from within a configuration file.


       -q, --quiet
              Hides all messages except errors.


       -v, --verbose
              Print extra information during the capture process.


       --version
              Print the version number and exit.


       -l, --loop <frequency>
              Continually capture images. The time between images is specified in seconds.

              Default behaviour is to capture a single image and exit.

              Note: The time to capture the next image is calculated relative to the epoch, so an image will not be captured immediately when  the  program
              is first started.


       --offset <seconds>
              Sets the offset to use when calculating when the next image is due in loop mode. Value can be positive or negative.


       -b, --background
              Run in the background. In this mode stdout and console logging are unavailable.


       --pid <filename>
              Saves the PID of the background process to the specified file. Ignored when not using background mode.


       --log [file/syslog:]<filename>
              Redirect log messages to a file or syslog. For example

              --log output.log
              --log file:output.log
              --log syslog


       --gmt  Use GMT instead of the local timezone when formatting text with strftime.


   Capture Options
       -d, --device [<prefix>:]<device name>
              Set the source or device to use. The source module is selected automatically unless specified in the prefix.

              Default is /dev/video0.

              Available source modules, in order of preference:

              V4L2 - Capture images from a V4L2 compatible video device.
              V4L1 - Capture images from a V4L1 compatible video device.
              FILE - Capture an image from a JPEG or PNG image file.
              RAW - Reads images straight from a device or file.
              TEST - Draws colour bars.


       -i, --input <input number or name>
              Set the input to use. You may select an input by either it's number or name.

              Default is "0".


       --list-inputs
              List available inputs for the selected source or device.

              fswebcam -d v4l2:/dev/video1 --list-inputs


       -t, --tuner <tuner number>
              Set the tuner to use.


       -f, --frequency <frequency>
              Set the frequency of the selected input or tuner. The value may be read as KHz or MHz depending on the input or tuner.


       -p, --palette <name>
              Try to use the specified image format when capturing the image.

              Default is to select one automatically.

              Supported formats:

              PNG
              JPEG
              MJPEG
              S561
              RGB32
              RGB24
              BGR32
              BGR24
              YUYV
              UYVY
              YUV420P
              BAYER
              SGBRG8
              SGRBG8
              RGB565
              RGB555
              Y16
              GREY


       -r, --resolution <dimensions>
              Set  the image resolution of the source or device. The actual resolution used may differ if the source or device cannot capture at the speci‐
              fied resolution.

              Default is "384x288".


       --fps <frames per second>
              Sets the frame rate of the capture device. This currently only works with certain V4L2 devices.

              Default is "0", let the device decide.


       -F, --frames <number>
              Set the number of frames to capture. More frames mean less noise in the final image, however capture times will be longer and moving  objects
              may appear blurred.

              Default is "1".


       -S, --skip <number>
              Set  the  number  of frames to skip. These frames will be captured but won't be use. Use this option if your camera sends some bad or corrupt
              frames when it first starts capturing.

              Default is "0".


       -D, --delay <delay>
              Inserts a delay after the source or device has been opened and initialised, and before the capture begins. Some devices need  this  delay  to
              let the image settle after a setting has changed. The delay time is specified in seconds.


       -R, --read
              Use read() to capture images. This can be slower but more stable with some devices.

              Default is to use mmap(), falling back on read() if mmap() is unavailable.


       -s, --set <name=value>
              Set a control. These are used by the source modules to control image or device parameters. Numeric values can be expressed as a percentage of
              there maximum range or a literal value, for example:

              --set brightness=50% --set framerate=5

              Non-numeric controls are also supported:

              --set lights=on

              V4L2 features a type of control called a 'button'. These controls do not take any value, but trigger an action. For example:

              --set "Restore Factory Settings"

              Control names and values are not case sensitive.

              Note: Available controls will vary depending in the source module and devices used. For more information see the --list-controls option.


       --list-controls
              List available controls and their current values for the selected source module and device. For example:

              fswebcam -d v4l2:/dev/video2 --list-controls


   Output Options
       These options are performed in the order they appear on the command line, only effecting images output later on the command line. For example:

              fswebcam -r 640x480 output1.jpeg --scale 320x240 output2.jpeg

              Will create two images, "output1.jpeg" containing a full resolution copy of the captured image and "output2.jpeg" containing  the  same  cap‐
              tured image but scaled to half the size.


       --no-banner
              Disable the banner.


       --top-banner
              Position the banner at the top of the image.


       --bottom-banner
              Position the banner at the bottom of the image.

              This is the default.


       --banner-colour <#AARRGGBB>
              Set the colour of the banner. Uses the web-style hexadecimal format (#RRGGBB) to describe the colour, and can support an alpha channel (#AAR‐
              RGGBB). Examples:

              "#FF0000" is pure red.
              "#80000000" is semi-transparent black.
              "#FF000000" is invisible (alpha channel is at maximum).
              Default is "#40263A93".


       --line-colour <#AARRGGBB>
              Set the colour of the divider line. See --banner-colour for more information.

              Default is "#00FF0000".


       --text-colour <#AARRGGBB>
              Set the colour of the text. See --banner-colour for more information.

              Default is "#00FFFFFF".


       --font <[file or font name]:[font size]>
              Set the font used in the banner. If no path is specified the path in the GDFONTPATH environment variable is searched for the font. Fontconfig
              names may also be used if the GD library has support.

              If no font size is specified the default of "10" will be used.

              Default is "sans:10".


       --no-shadow
              Disable the text shadow.


       --shadow
              Enable the text shadow.

              This is the default behaviour.


       --title <text>
              Set the main text, located in the top left of the banner.


       --no-title
              Clear the main text.


       --subtitle <text>
              Set the sub-title text, located in the bottom left of the banner.


       --no-subtitle
              Clear the sub-title text.


       --timestamp <text>
              Set the timestamp text, located in the top right of the banner. This string is formatted by strftime.

              Default is "%Y-%m-%d %H:%M (%Z)".


       --no-timestamp
              Clear the timestamp text.


       --info <text>
              Set the info text, located in the bottom right of the banner.


       --no-info
              Clear the info text.


       --underlay <filename>
              Load a PNG image and overlay it on the image, below the banner. The image is aligned to the top left.

              Note: The underlay is only applied when saving an image and is not modified by any of the image options or effects.


       --no-underlay
              Clear the underlay image.


       --overlay <filename>
              Load a PNG image and overlay on the image, above the banner. The image is aligned to the top left.

              Note: The overlay is only applied when saving an image and is not modified by any of the image options or effects.


       --no-overlay
              Remove the overlay image.


       --jpeg <factor>
              Set JPEG as the output image format. The compression factor is a value between 0 and 95, or -1 for automatic.

              This is the default format, with a factor of "-1".


       --png <factor>
              Set PNG as the output image format. The compression factor can be a value between 0 and 9, or -1 for automatic.


       --save <filename>
              Saves the image to the specified filename.

              Note: This isn't necessary on the command-line where a filename alone is enough to save an image.


       --revert
              Revert to the original captured image and resolution. This undoes all previous effects on the image.

              Note: This only reverts the image itself, and not options such as font, colours and overlay.


       --flip <direction[,direction]>
              Flips the image. Direction can be (h)orizontal or (v)ertical. Example:

              --flip h    Flips the image horizontally.
              --flip h,v  Flips the image both horizontally and vertically.


       --crop <dimensions[,offset]>
              Crop the image. With no offset the cropped area will be the center of the image. Example:

              --crop 320x240    Crops the center 320x240 area of the image.
              --crop 10x10,0x0  Crops the 10x10 area at the top left corner of the image.


       --scale <dimensions>
              Scale the image.

              Example: "--scale 640x480" scales the image up or down to 640x480.

              Note: The aspect ratio of the image is not maintained.


       --rotate <angle>
              Rotate the image in right angles (90, 180 and 270 degrees).

              Note: Rotating the image 90 or 270 degrees will swap the dimensions.


       --deinterlace
              Apply a simple deinterlacer to the image.


       --invert
              Invert all the colours in the image, creating a negative.


       --greyscale
              Remove all colour from the image.


       --swapchannels <c1c2>
              Swap colour channels c1 and c2. Valid channels are R, G and B -- for Red, Green and Blue channels respectively.

              Example: "--swapchannels RB" will swap the red and blue channels.


       --exec <command>
              Executes the specified command and waits for it to complete before continuing. The command line is formatted by strftime.


SIGNALS
       SIGHUP This causes fswebcam to reload it's configuration.


       SIGUSR1
              Causes fswebcam to capture an image immediately without waiting on the timer in loop mode.


KNOWN BUGS
       The spacing between letters may be incorrect. This is an issue with the GD library.


REPORTING BUGS
       Please report bugs to <phil@sanslogic.co.uk>.


SEE ALSO
        ncftpput(1), strftime(3)


AUTHOR
       Written by Philip Heron <phil@sanslogic.co.uk>.




fswebcam 20140113                                                     13 January 2014                                                           FSWEBCAM(1)
