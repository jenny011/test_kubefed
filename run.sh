# !/bin/bash

CURR=$PWD
# Export all the environmental vars (including your ethzid)
# comment it out if exported
source $CURR/env.sh
cd $BASEDIR
echo ">>>>> You are in $BASEDIR >>>>>"

if [ $# != 1 ] || [[ ! $1 =~ ^[0-9]+$ ]] || (($1 > 6))
then
	echo "Usage: ./run1.sh <a number>"
	echo "Valid numbers:"
	echo "- 0: No interference"
	echo "- 1: ibench-cpu"
	echo "- 2: ibench-l1d"
	echo "- 3: ibench-l1i"
	echo "- 4: ibench-l2"
	echo "- 5: ibench-llc"
	echo "- 6: ibench-membw"
	exit 1
fi

if [ $1 -ne "0" ]; then
	# Measure 1-6. ibench-<name>
	NAME=("cpu" "l1d" "l1i" "l2" "llc" "membw")
	BENCHMARK="ibench-${NAME[$(($1 - 1))]}"
	echo "You are setting up interference/$BENCHMARK.yaml"
	kubectl create -f interference/$BENCHMARK.yaml
	if [ $? -ne 0 ]; then
		echo "ERROR: interference/$BENCHMARK.yaml create failed."
		exit 1
	fi

	sleep 30
fi

NODES="$NODESDIR/$CLUSTERNAME.txt"
PODS="$PODSDIR/$CLUSTERNAME.txt"
# if READY is not 1/1 and STATUS is not Running, manually run get pods again
kubectl get pods -o wide > $PODS
if [ $? -ne 0 ]; then
	echo "ERROR: get pods info failed."
	echo "run 'kubectl get pods -o wide' manually in the terminal"
	exit 1
fi
echo "--------"
cat $NODES
echo "--------"
cat $PODS
echo "----do you see READY 1/1, STATUS Running for interference $1 you are creating?"
echo "--------if NO, run 'kubectl get pods -o wide' manually in the terminal."
echo "--------if YES, run experiments in the VMs."
echo "You can run ./kill.sh to delete a benchmark."

echo "!!!!! MUST delete the cluster after use: run ./delete.sh !!!!!"
