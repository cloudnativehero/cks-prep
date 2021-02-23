#!/bin/sh
# Use this script to initialize master

KUBE_VERSION=1.20.4
HOST_IP=`/sbin/ifconfig enp0s8 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'  | cut -d' ' -f2`
### init k8s
kubeadm init --apiserver-advertise-address=${HOST_IP} --kubernetes-version=${KUBE_VERSION} --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=NumCPU --skip-token-print
ip route add 10.96.0.0/16 dev enp0s8 src ${HOST_IP}

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml


echo
echo "### COMMAND TO ADD A WORKER NODE ###"
kubeadm token create --print-join-command --ttl 0
