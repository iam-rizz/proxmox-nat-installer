#!/bin/bash

# setup_network_bridge.sh
# Interactive script to create a NAT bridge (vmbr0) on Proxmox VE
# Reference: https://forum.proxmox.com/threads/create-private-network-bridge-with-nat.126232/

set -e
clear
BRIDGE_NAME="vmbr0"

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root!"
  exit 1
fi

mapfile -t IFACES < <(ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$')

if [[ ${#IFACES[@]} -eq 0 ]]; then
  echo "No network interfaces detected!"
  exit 1
fi

echo "Detected network interfaces:"
for i in "${!IFACES[@]}"; do
  echo "$((i+1))) ${IFACES[$i]}"
done

read -rp "Select WAN interface (number): " IFIDX
IFIDX=$((IFIDX-1))
WAN_IFACE="${IFACES[$IFIDX]}"

read -rp "Enter IP for the bridge (e.g. 10.10.10.1): " BRIDGE_IP
if ! [[ $BRIDGE_IP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo "Invalid IP format!"
  exit 1
fi

read -rp "Enter subnet/CIDR (e.g. 24 for 255.255.255.0): " BRIDGE_CIDR
if ! [[ $BRIDGE_CIDR =~ ^[0-9]{1,2}$ ]] || ((BRIDGE_CIDR < 8 || BRIDGE_CIDR > 32)); then
  echo "Invalid CIDR!"
  exit 1
fi

cat <<EOF
\nConfiguration Summary:
- WAN Interface : $WAN_IFACE
- Bridge Name   : $BRIDGE_NAME
- Bridge IP     : $BRIDGE_IP/$BRIDGE_CIDR
EOF

read -rp "Continue with configuration? (Y/n): " CONFIRM
CONFIRM=${CONFIRM,,}
if [[ $CONFIRM == "n" ]]; then
  echo "Cancelled."
  exit 0
fi

cp /etc/network/interfaces /etc/network/interfaces.bak.$(date +%F-%H%M%S)

if ! grep -q "$BRIDGE_NAME" /etc/network/interfaces; then
cat <<EOF >> /etc/network/interfaces
auto $BRIDGE_NAME
iface $BRIDGE_NAME inet static
    address  $BRIDGE_IP/$BRIDGE_CIDR
    bridge-ports none
    bridge-stp off
    bridge-fd 0
    post-up   echo 1 > /proc/sys/net/ipv4/ip_forward
    post-up   iptables -t nat -A POSTROUTING -s '$BRIDGE_IP/$BRIDGE_CIDR' -o $WAN_IFACE -j MASQUERADE
    post-down iptables -t nat -D POSTROUTING -s '$BRIDGE_IP/$BRIDGE_CIDR' -o $WAN_IFACE -j MASQUERADE
EOF
  echo "Configuration for $BRIDGE_NAME has been added to /etc/network/interfaces"
else
  echo "Bridge $BRIDGE_NAME already exists in /etc/network/interfaces"
fi

if ! grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf; then
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
  sysctl -w net.ipv4.ip_forward=1
fi

echo "Restarting networking service..."
systemctl restart networking

echo "\nNAT bridge $BRIDGE_NAME setup is complete!"
echo "Assign your VM to $BRIDGE_NAME and use gateway $BRIDGE_IP" 