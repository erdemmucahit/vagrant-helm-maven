##  To  create single master and two worker node cluster

##  To provision the cluster, execute the following command.

```shell
vagrant up
```

## Set Kubeconfig file variable.

```shell
cd vagrant-kubeadm-kubernetes
cd configs
export KUBECONFIG=$(pwd)/config
```

or you can copy the config file to .kube directory.

```shell
cp config ~/.kube/
```



