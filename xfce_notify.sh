#!/bin/bash
# anyDE-update-notifier.sh 0.1.0
# April 30, 2013
#
# Use with anyDE-update-check.sh
#
# see man xterm for options, to be used with anyDE-update-check.sh

notify-send -u critical "`date +"%A %-d, %B"`" "`date +"\-- %I:%M %P"`"
