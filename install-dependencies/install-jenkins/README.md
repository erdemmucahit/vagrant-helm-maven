##  To setup jenkins


```shell
kubectl apply -f jenkins-pvc.yaml
kubectl apply -f jenkins-service.yaml
kubectl apply -f jenkins-deployment.yaml
```


##  get initialadminpassword 


```shell
kubectl get po -n jenkins-dev
kubectl logs <pod-name> -n jenkins-dev
```




