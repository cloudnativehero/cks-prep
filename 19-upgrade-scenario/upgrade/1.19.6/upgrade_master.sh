#!/bin/sh

kubectl drain cks-master --ignore-daemonsets
kubectl get nodes

apt-get install kubeadm=1.19.6-00 kubelet=1.19.6-00 kubectl=1.19.6-00
kubeadm upgrade plan
kubeadm upgrade apply 1.19.6
kubectl get nodes
kubectl uncordon node cks-master

systemctl daemon-reload
systemctl restart kubelet

