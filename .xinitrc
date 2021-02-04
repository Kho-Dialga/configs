#!/bin/sh

# xinitrc runs automatically when you run startx.

# There are some small but important commands that need to be run when we start
# the graphical environment. I keep those commands in ~/config/xprofile because
# that file is run automatically if someone uses a display manager (login
# screen) and so they are needed there. To prevent doubling up commands, I
# source them here with the line below.

# export STATUSBAR="i3blocks" # Uncomment this line when using i3.
xrandr --output HDMI-A-0 --mode 1920x1080 --rate 144

. ~/.config/xprofile 2>/dev/null
#polybarlaunch
# Your default LARBS WM is determined in your `~/.profile` on login.  Here we
# run the proper command to run when the graphical environment starts.

# Comment/uncomment these lines depending on what wm you want to use. Also
# check the i3blocks line above.
ssh-agent awesome
