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
systemctl enable docker.service

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

# Init k8s cluster
# kubeadm config images pull
# kubeadm init

# Join k8s cluster
# kubeadm join 10.0.2.15:6443 --token m7ct8t.k895gy53bk6d1lu7 \
#     --discovery-token-ca-cert-hash sha256:4ee0ba534876536de67d2230d2dfe9b43e500970bfb1edac326776f147ebec28
