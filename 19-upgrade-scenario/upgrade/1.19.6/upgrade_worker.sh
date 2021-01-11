#!/bin/sh

kubectl drain cks-worker --ignore-daemonsets
kubectl get nodes

ssh root@cks-worker <<SCRIPT

apt-get install kubeadm=1.19.6-00 kubelet=1.19.6-00
kubeadm upgrade node

systemctl daemon-reload
systemctl restart kubelet

SCRIPT

kubectl uncordon cks-worker
kubectl get nodes

