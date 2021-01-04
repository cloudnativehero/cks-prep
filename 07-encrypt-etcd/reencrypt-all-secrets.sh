#!/bin/sh
kubectl get secrets -A -o yaml | kubectl replace -f -
