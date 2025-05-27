# instals Tiger operator for Calico network plugin
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml

# installs calico custom resource
curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml -O

cidr=$(kubectl -n kube-system get pod -l component=kube-controller-manager -o yaml | grep -i cluster-cidr)
sed -i "s/cidr: 192.168.0.0\/16/cidr: ${cidr}/g" custom-resources.yaml
kubectl create -f custom-resources.yaml