# upgrade control plane

## check existing kubeadm version
kubeadm version -o json

## unhold kubeadm and install lts version
sudo apt-mark unhold kubeadm

## check latest kubeadm version
sudo apt-cache madison kubeadm | tac

## install latest
sudo apt-get update -y
sudo apt-get install -y kubeadm=1.29.3-1.1

## hold kubeadm
sudo apt-mark hold kubeadm

## check available kubernetes version
sudo kubeadm upgrade plan

## upgrade control plane
kubeadm upgrade apply v1.29.3 

## check kubelet version
kubeadm version -o json

## drain the node to evict workloads
kubectl drain controlplane --ignore-daemonsets

## upgrade kubelet and kubectl 
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet=1.29.3-1.1 kubectl=1.29.3-1.1 && \
sudo apt-mark hold kubelet kubectl

## restart svc
sudo systemctl daemon-reload && \
sudo systemctl restart kubelet

## uncordon the node
kubectl uncordon controlplane

# upgrade worker node

## unhold kubeadm and install lts version
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=1.29.3-1.1 && \
sudo apt-mark hold kubeadm

## upgraade kubeadm
sudo kubeadm upgrade node

## drain the node
kubectl drain node01 --ignore-daemonsets

> if pods are using local storage, then we need to use --delete-local-data
sudo kubectl drain node01 --ignore-daemonsets --delete-local-data

## upgrade kubelet and kubectl
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet=1.29.3-1.1 kubectl=1.29.3-1.1 && \
sudo apt-mark hold kubelet kubectl


## restart kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet

## uncord the node
kubectl uncordon node01

# verify cluster
kubectl get nodes -o wide

kubectl get --raw='/readyz?verbose'
curl -k https://localhost:6443/livez?verbose

kubectl get po -n kube-system