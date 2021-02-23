#!/bin/sh
# Use this script to setup any node in your Kuberntes cluster 
# Either master or worker
# Source: http://kubernetes.io/docs/getting-started-guides/kubeadm/

### setup terminal
KUBE_VERSION=1.20.4

### install k8s and docker
apt-get remove -y kubelet kubernetes-cni
apt-get autoremove -y
systemctl daemon-reload

apt-get update
apt-get -y install linux-headers-$(uname -r)
apt-get install -y etcd-client vim build-essential bash-completion binutils apparmor-utils falco kubelet=${KUBE_VERSION}-00 kubeadm=${KUBE_VERSION}-00 kubectl=${KUBE_VERSION}-00 kubernetes-cni=0.8.7-00 trivy

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "storage-driver": "overlay2"
}
EOF
mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

# start docker on reboot
systemctl enable docker

#stop and disable falco
systemctl disable falco
systemctl stop falco

docker info | grep -i "storage"
docker info | grep -i "cgroup"

systemctl enable kubelet && systemctl start kubelet

