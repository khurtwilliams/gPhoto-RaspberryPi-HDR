gPhoto-RaspberryPi-HDR
======================

Utility to capture exposure bracketed images with a Raspberry for use in HDR photography

This project is related to my [blog post](http://islandinthenet.com/2013/02/18/hdr-photography-with-a-raspberry-pi/).

*February 2013*

This HDR solution is based on projects and ideas from several places

Project

*[gphoto2-timelapse - dwiel](https://github.com/dwiel) and [Zach's blog post](http://dwiel.net/blog/raspberry-pi-timelapse-camera/).

*[gpio from WiringPi: An implementation of most of the Arduino Wiring functions for the Raspberry Pi](https://projects.drogon.net/raspberry-pi/wiringpi/).

I found the information at thes link helpful

http://rpi.tnet.com/project/hardware/project001
http://elinux.org/RPi_Low-level_peripherals#GPIO_Driving_Example_.28Bash_shell_script.2C_using_sysfs.2C_part_of_the_raspbian_operating_system.29

*DESCRIPTION*

gphoto2-hdr allows you to create HDR photography using the Raspberry Pi (http://www.raspberrypi.org/), supported DSLR camera connected via USB (http://gphoto.org/proj/libgphoto2/support.php), and the gphoto2 unix tool (http://www.gphoto.org/).

*Installation*

Download and compile the WiringPi code to create gpio. You will need this to control the GPIO pins on the RPi and a switch to signal the main script to do it's work.

You will also need to install usbutils - Linux USB utilities - to obtain lsusb.  lsusb  is  a utility for displaying information about USB buses in the system and the devices connected to them. I found lsusb more useful for detecting when a camera was attached to the RPi and turned on.  I could have used gphoto2 with the autodetect switch but I found lsusb was faster.

You will also need to compile usbreset.  This handy piece of code helped reset the USB interface to the Nikon camera in between brackets sets.  I found that without usbreset that gphoto2 would generate a lot of errors using the Nikon.

You will need to install Perl to run the HDR scripts.  This might already be a part of your library.

*USE*

Once everything is installed, you need to tweak the script a bit to get it to work with different cameras. For example, I used lsusb to specific USB ID for my Nikon D40.  I used that in the script.  You will also need to determine the proper gphotos2 parameters for you camera.  Once you have the camera specific parameters and functions in place, you can use the Perl scripts to begin taking images.

perl hdr.pl

There is also an rc script which you can use to start the HDR script automatically whenever the computer (raspberry pi) is turned on.  To setup this feature run the following commands:

sudo ln ./rc.hdr /etc/init.d/rc.hdr
cd /etc/init.d/
sudo update-rc.d rc.hdr defaults

*ADDITIONAL INFORMATION & AUTHOR*

[HDR PHOTOGRAPHY WITH RASPBERRY PI AND GPHOTO2 – REVISION 2](http://islandinthenet.com/2013/02/18/hdr-photography-with-a-raspberry-pi/)
