yum update -y

# Install required packages.
yum install -y yum-utils device-mapper-persistent-data lvm2

# Add Docker repository.
yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker CE.
yum update -y && yum install -y docker-ce-18.09.9

# Create /etc/docker directory.
mkdir /etc/docker

# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker
systemctl daemon-reload
systemctl restart docker

# Enable docker service
systemctl enable docker

# Fix bug that iptables being bypassed
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Add k8s repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Install k8s base
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Enable kubelet
systemctl enable --now kubelet

# Turn off swap
swapoff -a

# Note:
#   Edit the host file (resolve hostname to private IP)
#   Edit /etc/sysconfig/kubelet, add `--node-ip=PRIVATE_IP` then restart kubelet

# On master node
#   Run following command to init the cluster, --pod-network-cidr is CNI provider's preffered IP range
#     kubeadm init \
#       --apiserver-advertise-address=172.16.0.100 \
#       --apiserver-cert-extra-sans=172.16.0.100 \
#       --pod-network-cidr=192.168.0.0/16
#   Or create new token
#     kubeadm token create
#   Export API server config: export KUBECONFIG=/etc/kubernetes/admin.conf
#   Install CNI pods: kubectl apply -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml

# On worker node
#   Join the cluster
