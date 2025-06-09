# create root CA crt and key
openssl req -x509 -sha256 -days 356 -nodes -newkey rsa:2048 -subj "/CN=demo.thebeginner86.io/C=US/L=San Francisco/O=thebeginner86.co" -keyout rooCA.key -out rootCA.crt

## create server private key
openssl genrsa -out server.key 2048

## create csr
openssl req -new -key server.key -out server.csr -config <(cat <<-EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = US
ST = California
L = San Fransisco
O = thebeginner86.co
OU = thebeginner86 
CN = demo.thebeginner86.com

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = demo.thebeginner86.com
DNS.2 = www.demo.thebeginner86.com
IP.1 = 192.168.14.5
IP.2 = 192.168.14.6
EOF
)

## generate ssl cert with self signed ca
openssl x509 -req -in server.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out server.crt -days 365 -sha256 -extfile <(cat <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = demo.thebeginner86.com

EOF
)

# for Nginx config
# server {

# listen   443;

# ssl    on;
# ssl_certificate    /etc/ssl/server.crt;
# ssl_certificate_key    /etc/ssl/server.key; # private key

# server_name your.domain.com;
# access_log /var/log/nginx/nginx.vhost.access.log;
# error_log /var/log/nginx/nginx.vhost.error.log;
# location / {
# root   /home/www/public_html/your.domain.com/public/;
# index  index.html;
# }

# }

