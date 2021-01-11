#!/bin/sh

kubectl drain cks-worker --ignore-daemonsets
kubect get nodes

apt-get install kubeadm=1.19.6-00 kubelet=1.19.6-00 kubectl=1.19.6-00
kubeadm upgrade plan
kubeadm upgrade apply 1.19.6
kubeadm get nodes
kubectl uncordon node cks-worker

systemctl daemon-reload
systemctl restart kubelet

