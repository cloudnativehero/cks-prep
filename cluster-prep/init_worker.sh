### init k8s
kubeadm reset -f
rm -rf /etc/cni/net.d /etc/kubernetes /var/lib/etcd /var/lib/kubelet /var/run/kubernetes /var/lib/cni
iptables -F
systemctl daemon-reload
service kubelet start
HOST_IP=`/sbin/ifconfig enp0s8 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'  | cut -d' ' -f2`
ip route add 10.96.0.0/16 dev enp0s8 src ${HOST_IP}

echo
echo "EXECUTE ON MASTER: kubeadm token create --print-join-command --ttl 0"
echo "THEN RUN THE OUTPUT AS COMMAND HERE TO ADD AS WORKER"
echo
