#!/bin/sh
# Clean up images with a search string. 
# name/tag provided as initial argument to the script

KUBE_VERSION=$1
docker rmi $(docker images | grep $KUBE_VERSION | tr -s ' ' | cut -d ' ' -f 3)
