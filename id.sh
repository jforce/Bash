#!/bin/bash
cat /proc/cpuinfo | grep name | tail -1 | awk -F': ' '{ print "CPU:" $2}' | sed -e 's/  //g'
cat /proc/meminfo | grep MemTotal | sed -e 's/ //g'
dmesg|grep "[sh]d[a-g]"|grep blocks|awk '{ print $5 ":" $10 $11 $12 }' | sed -e 's/ //g'
