#!/bin/sh
# Use this script to destroy master prior to shut down

kubeadm reset -f
rm -rf /etc/cni/net.d /etc/kubernetes /var/lib/etcd /var/lib/kubelet /var/run/kubernetes /var/lib/cni ~/.kube /opt/cni
iptables -F
