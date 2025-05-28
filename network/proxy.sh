# set proxy for the env
http_proxy=$1
https_proxy=$2

# set proxy for env
echo "$http_proxy" >> /etc/environment
echo "$https_proxy" >> /etc/environment
cat > .curlrc <<EOF
proxy = "$http_proxy"
EOF

## Set proxy for apt
cat > /etc/apt/apt.conf <<EOF
Acquire::http::Proxy "$http_proxy";
Acquire::https::Proxy "$https_proxy";
EOF


