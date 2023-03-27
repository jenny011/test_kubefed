# !/bin/bash

if [ $# -ne 1 ]; then
	echo "supply a cluster name"
	exit
else
	CLUSTERNAME=$1
fi

CURR=$PWD
source $CURR/env.sh

cd $BASEDIR
echo ">>>>> You are in $BASEDIR >>>>>"

# Create a kubernetes cluster with 1 master and 2 nodes
PROJECT=`gcloud config get-value project`
kops create -f $CLUSTERNAME.yaml
if [ $? -ne 0 ]; then
	echo "ERROR: $CLUSTERNAME.yaml create failed. Have you replaced the placeholders in $CLUSTERNAME.yaml?"
	exit 1
fi

# Create secret
kops create secret --name $CLUSTERNAME.k8s.local sshpublickey admin -i ~/.ssh/cloud-computing.pub
if [ $? -ne 0 ]; then
	echo "ERROR: secret create failed."
	exit 1
fi

# Deploy a cluster using "kops"
echo ">>>>> Deploying cluster $CLUSTERNAME... >>>>>"
echo "!!!!! MUST delete the cluster after use: run ./delete.sh !!!!!"
kops update cluster --name $CLUSTERNAME.k8s.local --yes --admin

# Wait until the cluster is ready to use
echo ">>>>> Wait until the cluster is ready... >>>>>"
echo ">>>>> You'll see many failures and errors until it's ready >>>>>"
kops validate cluster --wait 10m
if [ $? -ne 0 ]; then
	echo "ERROR: cluster validate failed."
	exit 1
fi

echo ">>>>> Cluster Ready! >>>>>"
echo "!!!!! MUST delete the cluster after use: run ./delete.sh !!!!!"

NODES="$NODESDIR/$CLUSTERNAME.txt"
# Output nodes info to a file
kubectl config use-context $CLUSTERNAME.k8s.local
kubectl get nodes -o wide > $NODES
if [ $? -ne 0 ]; then
	echo "run 'kubectl get nodes -o wide > <your-path-to-pods-output-file>' manually in the terminal"
	echo "ERROR: get nodes info failed."
	exit 1
fi
echo "--------"
cat $NODES
echo "--------"
echo "Now you can ssh into client-agent and client-measure in new terminal windows"
echo "gcloud compute ssh --ssh-key-file ~/.ssh/cloud-computing ubuntu@<server name> --zone europe-west4-a"

# # Run memcached
# kubectl create -f memcache-t1-cpuset.yaml
# if [ $? -ne 0 ]; then
# 	echo "ERROR: create memcache-t1-cpuset.yaml failed."
# 	exit 1
# fi

# kubectl expose pod some-memcached --name some-memcached-11211 --type LoadBalancer --port 11211 --protocol TCP
# if [ $? -ne 0 ]; then
# 	echo "ERROR: expose pod failed."
# 	exit 1
# fi

# sleep 60
# kubectl get service some-memcached-11211
# if [ $? -ne 0 ]; then
# 	echo "ERROR: get service failed."
# 	exit 1
# fi

echo "!!!!! MUST delete the cluster after use: run ./delete.sh !!!!!"

