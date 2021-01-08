#!/bin/sh
# Use this script to setup any node in your Kuberntes cluster 
# Either master or worker
# Source: http://kubernetes.io/docs/getting-started-guides/kubeadm/

### setup terminal
KUBE_VERSION=1.18.0
apt-get install -y bash-completion binutils apparmor-utils
echo 'colorscheme ron' >> ~/.vimrc
echo 'set tabstop=2' >> ~/.vimrc
echo 'set shiftwidth=2' >> ~/.vimrc
echo 'set expandtab' >> ~/.vimrc
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'alias c=clear' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
sed -i '1s/^/force_color_prompt=yes\n/' ~/.bashrc


### install k8s and docker
apt-get remove -y docker.io kubelet kubeadm kubectl kubernetes-cni docker-ce
apt-get autoremove -y
apt-get install -y etcd-client vim build-essential

###
docker rmi -f $(docker images -aq)

### install kube-bench
curl -L https://github.com/aquasecurity/kube-bench/releases/download/v0.3.1/kube-bench_0.3.1_linux_amd64.deb -o /tmp/kube-bench_0.3.1_linux_amd64.deb
sudo apt install /tmp/kube-bench_0.3.1_linux_amd64.deb -f
rm -rf /tmp/kube-bench*

### install falco
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://dl.bintray.com/falcosecurity/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list

### install kubesec

curl -L https://github.com/controlplaneio/kubesec/releases/download/v2.8.0/kubesec_linux_386.tar.gz -o /tmp/kubesec_linux_386.tar.gz
tar -xvf /tmp/kubesec_linux_386.tar.gz -C /tmp/kubesec/
cp /tmp/kubesec/kubesec /usr/bin/kubesec
rm -rf /tmp/kubesec*

apt-get update -y
apt-get -y install linux-headers-$(uname -r)
apt-get install -y falco

systemctl daemon-reload
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y docker.io kubelet=${KUBE_VERSION}-00 kubeadm=${KUBE_VERSION}-00 kubectl=${KUBE_VERSION}-00 kubernetes-cni=0.8.7-00

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

docker info | grep -i "storage"
docker info | grep -i "cgroup"

systemctl enable kubelet && systemctl start kubelet

#Pull images
kubeadm config images pull
