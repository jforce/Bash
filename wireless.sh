#!/bin/sh
# syntax
# if run without arguments, will prompt
# if run with arguments, you need
# wireless [essid] [rate] [WEPkey]
#  WEPkey can be "none" if you don't want to be prompted

INTERFACE="ath0"
IFCONFIG="/sbin/ifconfig"
IWLIST="/sbin/iwlist"
IWCONFIG="/sbin/iwconfig"
DHCLIENT="/sbin/dhclient"
FIREWALL="/usr/bin/firewall.sh"

# first just bring up the interface
$IFCONFIG $INTERFACE up 2> /dev/null
if [ $? -ne 0 ]
then
  echo "Cannot execute: $IFCONFIG $INTERFACE up"
  exit
fi  


# get the essid
if [ "$1" = "" ]
then

  # ask if the user wants a list
  echo -n "Would you like a list? [y]"
  read PROMPT
  case "$PROMPT" in
    [yY]	) $IWLIST $INTERFACE scanning | more;;
    ""	) $IWLIST $INTERFACE scanning | more;;
    *     ) echo "OK, find it yourself then";;
  esac

  # prompt for the rest
  echo -n "ESSID (name?):"
  read ESSID
else
  ESSID="$1"
fi

# get the rate
if [ "$2" = "" ]
then
  echo -n "rate [54M]:"
  read RATE
  if [ "$RATE" = "" ]
  then
    RATE="54M"
  fi  
else
  RATE="$2"
fi

# get the WEPkey
if [ "$3" = "" ]
then
  echo -n "WEPkey [none]:"
  read WEP
else
  WEP="$3"
  if [ "$WEP" = "none" ]
  then
    WEP=""
  fi
fi

# start running the commands NOW

$IWCONFIG $INTERFACE essid "$ESSID" 2> /dev/null
if [ $? -ne 0 ]
then
  echo "Cannot $IWCONFIG $INTERFACE essid $ESSID"
  exit
fi  

$IWCONFIG $INTERFACE rate "$RATE" 2> /dev/null
if [ $? -ne 0 ]
then
  echo "Cannot $IWCONFIG $INTERFACE rate $RATE"
  exit
fi  

# now set the key, if necessary
if [ "$WEP" != "" ]
then
  $IWCONFIG $INTERFACE key "$WEP" 2> /dev/null
  if [ $? -ne 0 ]
  then
    echo "Cannot $IWCONFIG $INTERFACE key $WEP"
    exit
  fi  
fi  

$DHCLIENT $INTERFACE 2> /dev/null
if [ $? -ne 0 ]
then
  echo "Cannot $DHCLIENT $INTERFACE"
  exit
fi  

$FIREWALL $INTERFACE
