# static ip

cat > /etc/netplan/50-cloud-init.yaml << EOF
network:
  version: 2
  rendered: networkd
  ethernets:
    eth0:
      dhcp4: false
      dhcp6: false
      addresses:
        - 192.168.1.122/24
      routes:
        - to:
          via: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
          - 8.8.4.4
EOF

sudo netplan apply
