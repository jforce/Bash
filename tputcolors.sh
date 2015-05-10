#!/bin/bash
# tput text capabilities

echo
echo -e "$(tput bold) reg  bld  und   tput-command-colors$(tput sgr0)"

for i in $(seq 1 7); do
  echo " $(tput setaf $i)Texto$(tput sgr0) $(tput bold)$(tput setaf $i)Texto$(tput sgr0) $(tput sgr 0 1)$(tput setaf $i)Texto$(tput sgr0)  \$(tput setaf $i)"
done

echo "'tput bold' Negrito         $(tput bold)"
echo "'tput sgr 0 1' Sublinhado      $(tput sgr 0 1)"
echo "'tput sgr0' Reset           $(tput sgr0)"
echo
