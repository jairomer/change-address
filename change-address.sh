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
hex=''          # Random hexadecimal number

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
# Arguments 
function generateHexVal() {
    rand=$(echo $RANDOM % 16 | bc)
    case "$rand" in
    "0")
        $hex="0"
        ;;
    "1")
        $hex="1"
        ;;
    "2")
        $hex="2"
        ;;
    "3")
        $hex="3"
        ;;
    "4")
        $hex="4"
        ;;
    "5")
        $hex="5"
        ;;
    "6")
        $hex="6"
        ;;
    "7")
        $hex="7"
        ;;
    "8")
        $hex="8"
        ;;
    "9")
        $hex="9"
        ;;
    "10")
        $hex="A"
        ;;
    "11")
        $hex="B"
        ;;
    "12")
        $hex="C"
        ;;
    "13")
        $hex="D"
        ;;
    "14")
        $hex="E"
        ;;
    "15")
        $hex="F"
        ;;
esac
}

# generateRandomMac
# Arguments : None
function generateRandomMac {

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
# 	Otherwise generate a random mac using script mac-hasher.py.
# 	To use this script, I had to indicate its location.
HASHER='python /home/jaime/bin/mac-hasher.py' 
if [ -z "$2" ]
then 
	new_mac=$($HASHER)
	echo "new mac: $new_mac"

else
	new_mac=$2
fi
IFACE=$1 

# load new mac into selected interface.
sudo ifconfig $IFACE down
sudo ifconfig $IFACE hw ether $new_mac
sudo ifconfig $IFACE up
sudo ifconfig $IFACE | grep HW

# renew ip address for provided interface.
sudo dhclient -r -v $IFACE
countdown 3
sudo dhclient -v $IFACE
echo 
echo done
exit

