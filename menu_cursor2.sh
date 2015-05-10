#!/bin/bash
       E="echo -e";e="echo -en";trap "R;exit" 2
     ESC=$( $e "\033")
    TPUT(){ $e "\033[${1};${2}H";}
   CLEAR(){ $e "\033c";}
   CIVIS(){ $e "\033[?25l";}
    DRAW(){ $e "\033%@\033(0";}
   WRITE(){ $e "\033(B";}
    MARK(){ $e "\033[7m";}
  UNMARK(){ $e "\033[27m";}
    BLUE(){ $e "\033c\033[H\033[J\033[37;44m\033[J";};BLUE
       C(){ CLEAR;BLUE;}
    HEAD(){ MARK;TPUT 1 4
            $E "BASH SELECTION MENU                       ";UNMARK
            DRAW
            for each in $(seq 1 9);do
             $E "   x                                        x"
            done;WRITE;}
            i=0; CLEAR; CIVIS;NULL=/dev/null
    FOOT(){ MARK;TPUT 11 4
            printf "ENTER=SELECT, UP/DN=NEXT OPTION           ";UNMARK;}
   ARROW(){ read -s -n3 key 2>/dev/null >&2
            if [[ $key = $ESC[A ]];then echo up;fi
            if [[ $key = $ESC[B ]];then echo dn;fi;}
POSITION(){ if [[ $cur = up ]];then ((i--));fi
            if [[ $cur = dn ]];then ((i++));fi
            if [[ i -lt 0   ]];then i=$LM;fi
            if [[ i -gt $LM ]];then i=0;fi;}
 REFRESH(){ after=$((i+1)); before=$((i-1))
            if [[ $before -lt 0  ]];then before=$LM;fi
            if [[ $after -gt $LM ]];then after=0;fi
            if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
            if [[ $after -eq 0   ]] || [[ $before -eq $LM ]];then
            UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
      M0(){ TPUT 3 20; $e "Option0";}
      M1(){ TPUT 4 20; $e "Option1";}
      M2(){ TPUT 5 20; $e "Option2";}
      M3(){ TPUT 6 20; $e "Option3";}
      M4(){ TPUT 7 20; $e "Option4";}
      M5(){ TPUT 8 20; $e "ABOUT  ";}
      M6(){ TPUT 9 20; $e "EXIT   ";}
     LM=6    #Last Menu number
    MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    INIT(){ BLUE;HEAD;FOOT;MENU;}
      SC(){ REFRESH;MARK;$S;cur=`ARROW`;}
      ES(){ MARK;$e "\nENTER = main menu ";$b;read;INIT;};INIT
while [[ "$O" != " " ]]; do case $i in
      0) S=M0;SC;if [[ $cur = "" ]];then C;$e "o0:\n$(w        )\n";ES;fi;;
      1) S=M1;SC;if [[ $cur = "" ]];then C;$e "o1:\n$(ifconfig )\n";ES;fi;;
      2) S=M2;SC;if [[ $cur = "" ]];then C;$e "o2:\n$(df -h    )\n";ES;fi;;
      3) S=M3;SC;if [[ $cur = "" ]];then C;$e "o3:\n$(route -n )\n";ES;fi;;
      4) S=M4;SC;if [[ $cur = "" ]];then C;$e "o4:\n$(date     )\n";ES;fi;;
      5) S=M5;SC;if [[ $cur = "" ]];then C;$e "o5:\n$($e by oTo)\n";ES;fi;;
      6) S=M6;SC;if [[ $cur = "" ]];then C;exit 0;fi;;
esac;POSITION;done
