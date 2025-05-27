# connects worker node to master node

cmd=$(kubeadm token create --print-join-command)
sudo $cmd