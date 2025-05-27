# dynamic ip

cat > /etc/netplan/50-cloud-init.yaml << EOF
network:
  version: 2
  rendered: networkd
  ethernets:
    eth0:
      dhcp4: yes
      dhcp6: yes
EOF

sudo netplan apply
