#!/bin/sh
xrandr --output HDMI-2 --off --output HDMI-1 --mode 1280x960 --pos 0x0 --rotate normal --output DP-1 --off --output eDP-1 --primary --mode 1920x1080 --pos 0x960 --rotate normal --output DP-2 --off
~/.screenlayout/refresh.sh
