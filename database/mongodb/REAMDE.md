# MongoDB

## Prerequiste

### Storage Provisioner

There are many ways to achieve this. For cloud providers this should be preconfigured. For onprem deployment one can use Longhorn, Minio, K8s Sig/NFS
```
git clone https://github.com/kubernetes-sigs/nfs-ganesha-server-and-external-provisioner.git
cd nfs-ganesha-server-and-external-provisioner
kubectl create -f deploy/kubernetes/deployment.yaml
kubectl create -f deploy/kubernetes/rbac.yaml
kubectl create -f deploy/kubernetes/class.yaml
```


## Installation

MongoDB Enterprise K8s operator is the component that helps in Enterprise MongoDB deployment

### Add helm repo and deploy enterprise operator
```
helm repo add mongodb https://mongodb.github.io/helm-charts
helm repo update
helm install enterprise-operator mongodb/enterprise-operator --namespace mongodb --create-namespace
```

### Create secret for admin user

```
kubectl create secret generic ops-manager-secret -n mongodb \  --from-literal=Username="test" \
--from-literal=Password="test" \
--from-literal=FirstName="test" \  
--from-literal=LastName="test"
```



