#!/bin/bash
#Daniel Schwartz
#This script collects the number of bytes received / transmitted per second for every Interface used.
#22.01.2015 v1.1

#Log File Location
LOGFILE="LOGFILE.log"
#Print current time in a variable
TIMESTAMP=$(date)
#Check Operating System
OS=$(uname)

if [ "$OS" = "Linux" ]; then
	NIC_LINUX=$(/sbin/ifconfig | grep -m1 'encap:Ethernet' | cut -d' ' -f1)
	for line in $NIC_LINUX
	do
		TXbs=$(cat /sys/class/net/$line/statistics/tx_bytes)
		RXbs=$(cat /sys/class/net/$line/statistics/rx_bytes)
		echo "$TIMESTAMP" NIC=$line RXbs="$RXbs" TXbs="$TXbs" >> $LOGFILE
	done
elif [ "$OS" = "SunOS" ]; then 
	NIC_SOL=$(/sbin/ifconfig -a | grep BROADCAST | grep 'flags' | cut -d':' -f1)
	for line in $NIC_SOL
	do
		RXbs=$(/sbin/dladm show-dev -p $line -s| tail -1 | awk '{print $3}')
		TXbs=$(/sbin/dladm show-dev -p $line -s| tail -1 | awk '{print $6}')
		echo "$TIMESTAMP" NIC=$line RXbs="$RXbs" TXbs="$TXbs" >> $LOGFILE
	done
elif [ "$OS" = "AIX" ]; then
	NIC_AIX=$(ifconfig -a |grep -v LOOPBACK | grep BROADCAST | grep 'flags' | cut -d':' -f1)
	for line in $NIC_AIX
	do
		TXbs=$(entstat $line | grep Bytes | cut -d':' -f2|awk '{print $1}')
		RXbs=$(entstat $line | grep Bytes | cut -d':' -f3|awk '{print $1}')
		echo "$TIMESTAMP" NIC=$line RXbs="$RXbs" TXbs="$TXbs" >> $LOGFILE
	done
fi
