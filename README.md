# TODO
rename context cluster1 \
dns https://medium.com/google-cloud/global-kubernetes-in-3-steps-on-gcp-8a3585ec8547

# How to Kubefed
[kubefed user guide](https://github.com/kubernetes-sigs/kubefed/blob/master/docs/userguide.md)
https://medium.com/expedia-group-tech/managing-a-federated-kubernetes-cluster-using-kubefed-v2-5f115dbdbe05\
https://www.sobyte.net/post/2022-03/kubefed/
https://www.sobyte.net/post/2022-03/k8s-kubefed/
https://learnk8s.io/bite-sized/connecting-multiple-kubernetes-clusters
https://kubernetes.io/blog/2018/12/12/kubernetes-federation-evolution/
https://betterprogramming.pub/build-a-federation-of-multiple-kubernetes-clusters-with-kubefed-v2-8d2f7d9e198a
https://faun.pub/multi-cloud-multi-region-kubernetes-federation-part-1-3f2b5f7db62c

## Local machine

### Prereqs
Error: Kubernetes cluster unreachable: The gcp auth plugin has been removed. Please use the "gke-gcloud-auth-plugin" kubectl/client-go credential plugin instead. See https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke for further details \

gcloud components install gke-gcloud-auth-plugin \
export USE_GKE_GCLOUD_AUTH_PLUGIN=True \
install kubectl \
install kubefedctl: \
install helm: https://helm.sh/docs/intro/install/ \
`$ ./setup.sh`

### Deploy k8s clusters
`$ ./deploy.sh [cluster name]` \
The host cluster federates all the clusters. \
Each cluster has its own context.\

### Work in the host cluster context
```
$ kubectl config current-context
$ kubectl config get-contexts
$ kubectl config use-context [host-cluster]
```
*Always switch context to host after deploying a new cluster*

### GKE
https://github.com/kubernetes-sigs/kubefed/blob/master/docs/environments/gke.md

### Install Kubefed using Helm
```
$ ./helm repo add kubefed-charts https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts
$ ./helm repo list
$ ./helm --namespace kube-federation-system upgrade -i kubefed kubefed-charts/kubefed --create-namespace
```

Verify installation __in the host cluster__
```
$ kubectl get svc -n kube-federation-system
$ kubectl get deploy -n kube-federation-system
```

*Tiller is now automatically installed*

### Add clusters to a federation
[cluster registration commands](https://github.com/kubernetes-sigs/kubefed/blob/master/docs/cluster-registration.md#unjoining-clusters) \
```$ ./kubefedctl join [member cluster] --cluster-context [member cluster] --host-cluster-context [host cluster] --v=2``` \
List all kubefed member clusters \
```$ kubectl -n kube-federation-system get kubefedclusters``` \
`unjoin` existing clusters

### Run an app a federation
```$ kubectl apply -f [app].yaml``` \
Check locations where the app is running __in the host cluster__ \
```$ kubectl describe federateddeployment go-app --namespace go-app```



# Legacy from CCA Project Part 1

## Do these ONCE
1. add to .bashrc: export PATH=$PATH:<your-path>/google-cloud-sdk/bin
2. `gcloud init` with cca-eth-2022-group-4, do NOT configure any default computer region and zone
3. `gcloud compute zones list` to enable compute engine API
4. `gcloud auth application-default login` to configure your default credentials
5. cd ~/.ssh
6. ssh-keygen -t rsa -b 4096 -f cloud-computing
7. `chmod +x <every>.sh`
8. Fill in env1.sh

### Preparation
1. If you deleted or haven't created your bucket, run `./setup1.sh` to create it.

## Run experiments
1. `./deploy1.sh`: deploy the cluster, the cluster should be running if no errors.
2. ssh into client-agent and client-measure
3. `./run1.sh <benchmark number>`: run benchmark
4. `./kill1.sh <benchmark number>`: teardown benchmark
5. `./delete.sh`: delete the cluster, MUST do if finished using cluster
