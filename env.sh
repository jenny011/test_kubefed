# !/bin/bash

BASEDIR=$PWD
echo $BASEDIR

export KOPS_STATE_STORE=gs://test-kubefed/
export KOPS_FEATURE_FLAGS=AlphaAllowGCE
export NODESDIR=$BASEDIR/nodes
export PODSDIR=$BASEDIR/pods