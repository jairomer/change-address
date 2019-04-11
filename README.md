# change-address.sh

A linux bash script to randomly generate and set a MAC address on the 
indicated network interface.

Will also renew the IP address given by the DHCP server, effectively 
changing the interface's identity on the local network.

### Usage

```
./change-address.sh <interface> [<new mac>]
```
