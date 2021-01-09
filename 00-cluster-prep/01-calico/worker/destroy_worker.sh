#!/bin/sh
# Use this script to destroy worker node prior to shut down

kubeadm reset -f
rm -rf ~/.kube /etc/cni/net.d /etc/kubernetes /var/lib/etcd /var/lib/kubelet /var/run/kubernetes /var/lib/cni
iptables -F
