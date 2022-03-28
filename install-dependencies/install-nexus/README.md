##  To setup Nexus


```shell
kubectl create namespace nexus
kubectl apply -f nexus-pv.yaml
kubectl apply -f nexus-pvc.yaml
kubectl apply -f nexus-deployment.yaml
kubectl apply -f nexus-service.yaml

```

## Now you will be able to access nexus on any of the Kubernetes node IP on port 32000/nexus as we have exposed the node port.

## If you see that pv is not bound you may need to bound it. 

## while for Nexus 3 >= 3.17 you need to get the password from within the container with cat /nexus-data/admin.password
