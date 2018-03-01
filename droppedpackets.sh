#!/bin/bash

#Find ifconfig
IFCONFIG=$(/usr/bin/which ifconfig)
#Logfile name
LOGFILE=interface_dropped.log
#print timestamp
TIMESTAMP=$(date)

NIC_LINUX=$($IFCONFIG | grep -m1 'encap:Ethernet' | cut -d' ' -f1)
        for line in $NIC_LINUX
        do
                TXd=$(cat /sys/class/net/$line/statistics/tx_dropped)
                RXd=$(cat /sys/class/net/$line/statistics/rx_dropped)
                echo "$TIMESTAMP" NIC=$line RXdropped="$RXd" TXdropped="$TXd" >> $LOGFILE
        done
