#!/bin/bash

#  ---------------------------------------------------------------------------
#  "THE BEER-WARE LICENSE" (Revision 42):
#  <jairomer@pm.me> wrote this file.  As long as you retain this notice you
#  can do whatever you want with this stuff. If we meet some day, and you
#  think this stuff is worth it, you can buy me a beer in return.
#  ---------------------------------------------------------------------------
#
# This utlity will change the MAC address of the interface indicated by the
# first parameter.
#
# Optionally, you can indicate a specific MAC address as second parameter.
#

# Globals
mac=''          # Empty mac Address

# countdown $1: 	Starts a countdown.
# Paramenter: 		Time in seconds
function countdown {
	c=$1
	while [ $c -gt 0 ]
	do
		echo $c
		sleep 1
		c=$[$c-1]
	done
}

# generateHexVal:
# Arguments : None, but requires shell with $RANDOM
# Results : 'hex' Global variable
function generateHexVal {
    rand=$(echo $RANDOM % 16 | bc)
    case "$rand" in
    	"10")	hex="A"
			 	echo $hex 	;;
    	"11") hex="B"
				echo $hex 	;;
    	"12") hex="C"
				echo $hex 	;;
    	"13") hex="D"
				echo $hex 	;;
    	"14") hex="E"
				echo $hex 	;;
    	"15") hex="F"
				echo $hex 	;;
			*) 	hex="$rand"
			echo $hex 	;;
		esac
}

# generateRandomMac
# Arguments : None
# Results : 'mac' Global variable
function generateRandomMac {
	let sep=0			# Separator loop.
	let field=1		# Field loop.
	mac=""	  		# MAC address.
	# A mac address is composed of 6 fiealds, 2 values each.
	# 	XX:XX:XX:XX:XX:XX
	# Generate the first 5 fields
	while [ $field -lt 6 ]
	do
		# Create random field
		while [ $sep -lt 2 ]
		do
			let sep=sep+1
			# Modify global variable 'hex' to get a random hexadecimal number.
			hex="$(generateHexVal)"
			#echo $hex
			mac="$mac$hex"
			#echo $mac
		done

		let sep=0
	 	let field++
		mac="$mac:"
	done

	let sep=0
	# Generate 6th field without separator
	while [ $sep -lt 2 ]
	do
		let sep++
		hex="$(generateHexVal)"
		mac="$mac$hex"
	done

	echo $mac
}

# we need to be root, ask for permissions.
if [ $EUID -ne 0 ]
then
#	SCRIPT_PATH="$( cd "$(dirname $0)" ; pwd -P )"
#	sudo bash $SCRIPT_PATH/change-mac.sh $1 $2
	sudo bash $0 $1 $2
	exit
fi

# check that at least the first parameter is given.
if [ -z "$1" ]
then
	echo 'supply interface to modify.'
	echo
	echo "Usage: $0 <interface> [<new mac>]"
	exit
fi

# handle new mac.
# 	If provided, use that one.
# 	Otherwise generate a random mac.
if [ -z "$2" ]
then
	mac="$(generateRandomMac)"

	echo "new mac: $mac"

else
	mac=$2
fi
IFACE=$1

# load new mac into selected interface.
sudo ifconfig $IFACE down
sudo ifconfig $IFACE hw ether $mac
sudo ifconfig $IFACE up
sudo ifconfig $IFACE | grep HW

# renew ip address for provided interface.
sudo dhclient -r -v $IFACE
countdown 3
sudo dhclient -v $IFACE
echo
echo done
exit
