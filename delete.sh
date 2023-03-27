# !/bin/bash

if [ $# -ne 1 ]; then
	echo "supply a cluster name"
	exit
else
	CLUSTERNAME=$1
fi

CURR=$PWD
# Export all the environmental vars (including your ethzid)
# comment it out if exported
source $CURR/env.sh

cd $BASEDIR
echo ">>>>> You are in $BASEDIR >>>>>"

echo ">>>>> Deploying cluster $CLUSTERNAME... >>>>>"
kops delete cluster $CLUSTERNAME.k8s.local --yes
if [ $? -ne 0 ]; then
	echo "ERROR: DANGEROUS!!! delete cluster failed."
	exit 1
fi