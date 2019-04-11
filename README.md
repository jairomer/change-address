# change-address

A linux bash script to either set or randomly generate a MAC address to set
on the selected NIC.

Will also renew the IP address given by the DHCP server on the network,
effectively changing its identity.

### Usage

```
./change-address.sh <interface> [<new mac>]
```
