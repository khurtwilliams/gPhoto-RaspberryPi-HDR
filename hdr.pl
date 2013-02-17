#!/usr/bin/perl

use strict;
use boolean;

# I got these from using gphoto2 --auto-detect and lsusb
# change this for your specific camera
my $camera_model         = "Nikon DSC D40 (PTP mode)";
my $camera_device_number = "04b0:0414";
my ( $bus, $device ) = ();

#################################################
#
# Make sure the Nikon is turned on and then reset
# the USB port and the camera
#
#################################################

sub reset_nikon {
    my ( $bus, $device ) = @_;

    # get a list of devices
    # NOTE: Once I found out the device number for my Nikon I hard coded this
    # 04b0:0414 is my Nikon D40
    my $result = `/usr/bin/lsusb -d 04b0:0414`;
    return false if ( $result !~ /Nikon/ );

    #Once the Nikon is turned on rest the USB connection
    ( $bus, $device ) =
      ( $result =~ /Bus\s(\d{3})\sDevice\s(\d{3})\:./ )[ 0, 1 ];

    $_[0] = $bus;
    $_[1] = $device;
    system("/home/pi/bin/usbreset /dev/bus/usb/$bus/$device");
    return true;
}

#################################################
#
# Sets up the GPIO 4 port to check for a button
# press.  Loops until the button is pressed
#
#################################################

# Setup the port First
sub setup_gpio_port() {
    system("/usr/local/bin/gpio -g mode 4 in");
    system("/usr/local/bin/gpio -g mode 4 up");
}

# Wait for the button to be pushed
sub button_pushed() {

    # Loop Looking for a button press
    my $value = `/usr/local/bin/gpio -g read 4`;

    return false if ( $value == 1 );
    return true  if ( $value == 0 );

}

#take 5 bracketed images
sub take_photos {
    my ( $bus, $device ) = @_;
    system(
"/usr/bin/gphoto2 --quiet \ --camera \"$camera_model\" \ --port \"usb:$bus,$device\" \ --set-config /main/imgsettings/iso=0 \ --set-config /main/settings/capturetarget=1 \ --set-config-value /main/capturesettings/exposurecompensation=0 \ --capture-image \ --set-config-value /main/capturesettings/exposurecompensation=-2000 \ --capture-image \ --set-config-value /main/capturesettings/exposurecompensation=-4000 \ --capture-image \ --set-config-value /main/capturesettings/exposurecompensation=2000 \ --capture-image \ --set-config-value /main/capturesettings/exposurecompensation=4000 \ --capture-image"
    );
}

#################################################
#
# main
#
#################################################

#setup gpio ports
setup_gpio_port();

#wait for the Nikon to be turned on
while ( !reset_nikon( $bus, $device ) ) {}

#main loop
while (true) {

    #wait for the button to be pressed
    next if ( !button_pushed() );

    #take some photos
    take_photos( $bus, $device );

    #reset the camera for the next bracket set
    reset_nikon( $bus, $device );
}
