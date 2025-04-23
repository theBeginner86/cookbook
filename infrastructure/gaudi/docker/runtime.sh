#!/bin/sh

sudo tee /etc/docker/daemon.json <<EOF
{
   "runtimes": {
      "habana": {
            "path": "/usr/bin/habana-container-runtime",
            "runtimeArgs": []
      }
   }
}
EOF

sudo systemctl restart docker