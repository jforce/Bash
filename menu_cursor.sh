#!/bin/bash

 
menu_rotation()
 {
 #Variables
 CHOIX1="Rotation 1"
 CHOIX2="Rotation 2"
 CHOIX3="Rotation 3"
 CHOIX4="Rotation 4"
 CHOIX5="Rotation 5"
 CHOIX6="Rotation 6"
 CHOIX7="Rotation 7"
 CHOIX8="Rotation 8"
 #/Variables
 
 clear
 echo
 echo ============================
 echo "      Menu Rotation      "
 echo ============================
 PS3="Votre choix "
 
 select menu in "$CHOIX1" "$CHOIX2" "$CHOIX3" "$CHOIX4" "$CHOIX5" "$CHOIX6" "$CHOIX7" "$CHOIX8" "Back" "Quit"
     do
         case $menu in
         "${CHOIX1}")    echo
         echo "Choix 1"
         break 1 ;;
         
         "${CHOIX2}")    echo
         echo "Choix 1"
         break 1 ;;
         
         "${CHOIX3}")    echo
         echo "Choix 1"
         break 1 ;;
         
         "${CHOIX4}")    echo
         echo "Choix 1"
         break 1 ;;
         
         "${CHOIX5}")    echo
         echo "Choix 1"
         break 1 ;;
         
         "${CHOIX6}")    echo
         echo "Choix 1"
         break 1 ;;
         
         "${CHOIX7}")    echo
         echo "Choix 1"
         break 1 ;;
         
         "${CHOIX8}")    echo
         echo "Choix 1"
         break 1 ;;
         
         "Back")       echo
         main_menu
         break 2 ;;
         
         "Quit")      echo
         exit ;;
         
         *)              echo
         echo "Mauvaise réponse"
         esac
     done             
 }
menu_rotation
