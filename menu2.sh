#!/bin/bash
# clear the screen
tput clear

# Title
tput cup 3 15
echo "Script Name Here"

tput cup 5 17

# Reverse video mode
tput rev
echo "M E N U"
tput sgr0

tput cup 7 15
echo "1. Add User"

tput cup 8 15
echo "2. Delete User"

tput cup 9 15
echo "3. Reboot"

# Bold mode
tput bold
tput cup 11 15
read -p "Enter your Selection [1-3] selection: "

# Clear screen and reset terminal mode
tput clear
tput sgr0
tput rc
