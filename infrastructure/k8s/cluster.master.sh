# sets node_ip same as the host_ip
# this is very critical otherwise kubeadm init will fail due to precheck hooks not being able to reach the ip
sudo apt-get install -y jq

local_ip="$(ip --json addr show eth0 | jq -r '.[0].addr_info[] | select(.family == "inet") | .local')"

cat > /etc/default/kubelet << EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF


cat > kubeadm.config << EOF 
apiVersion: kubeadm.k8s.io/v1beta4
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: "192.168.249.201"
  bindPort: 6443
nodeRegistration:
  name: "controlplane"

---
apiVersion: kubeadm.k8s.io/v1beta4
kind: ClusterConfiguration
kubernetesVersion: "v1.32.0"
controlPlaneEndpoint: "192.168.249.201:6443"
apiServer:
  extraArgs:
    - name: "enable-admission-plugins"
      value: "NodeRestriction"
    - name: "audit-log-path"
      value: "/var/log/kubernetes/audit.log"
controllerManager:
  extraArgs:
    - name: "node-cidr-mask-size"
      value: "24"
scheduler:
  extraArgs:
    - name: "leader-elect"
      value: "true"
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/12"
  dnsDomain: "cluster.local"

---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: "systemd"
syncFrequency: "1m"

---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
conntrack:
  maxPerCore: 32768
  min: 131072
  tcpCloseWaitTimeout: "1h"
  tcpEstablishedTimeout: "24h"
EOF

sudo kubeadm init --config=kubeadm.config

# move kubeconfig to home dir
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
