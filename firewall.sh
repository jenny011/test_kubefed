# !/bin/bash

# kubectl create clusterrolebinding jinzhu-cluster-admin-binding --clusterrole=cluster-admin \
#   --user=$(gcloud config get-value core/account) --context gke_ml-elasticity_us-west1-a_jz-test-controller
# kubectl create clusterrolebinding jinzhu-cluster-admin-binding --clusterrole=cluster-admin \
#   --user=$(gcloud config get-value core/account) --context gke_ml-elasticity_us-west1-a_jz-test-1

CLUSTER_NAME=cluster1
CLUSTER_REGION=us-west1-a
VPC_NETWORK=$(gcloud container clusters describe $CLUSTER_NAME --zone $CLUSTER_REGION --format='value(network)')
MASTER_IPV4_CIDR_BLOCK=$(gcloud container clusters describe $CLUSTER_NAME --zone $CLUSTER_REGION--format='value(ipAllocationPolicy.clusterIpv4CidrBlock)')

gcloud compute firewall-rules create "private-allow-apiserver-to-admission-webhook-8443" \
      --allow tcp:8443 \
      --network="$VPC_NETWORK" \
      --source-ranges="$MASTER_IPV4_CIDR_BLOCK" \
      --description="Allow apiserver access to admission webhook pod on port 8443" \
      --direction INGRESS