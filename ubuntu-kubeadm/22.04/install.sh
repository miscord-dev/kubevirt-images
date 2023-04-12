#! /bin/bash

cat << EOF > /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

cat << EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

cat << EOF > /etc/sysctl.d/reverse-path-filter.conf
net.ipv4.conf.default.rp_filter     = 0
net.ipv4.conf.*.rp_filter           = 0
EOF

cat << EOF > /etc/sysctl.d/max-user-watches.conf
fs.inotify.max_user_watches=16184
EOF

cat << EOF /etc/systemd/system.conf.d/accounting.conf
[Manager]
DefaultCPUAccounting=yes
DefaultMemoryAccounting=yes
DefaultBlockIOAccounting=yes
EOF

cat << EOF > /etc/containerd/config.toml
version = 2
root = "/var/lib/containerd"
state = "/run/containerd"
subreaper = true
oom_score = -999
[grpc]
address = "/run/containerd/containerd.sock"
uid = 0
gid = 0
[plugins."io.containerd.grpc.v1.cri"]
enable_selinux = true
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
runtime_type = "io.containerd.runc.v2"
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
SystemdCgroup = true
EOF

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl ca-certificates curl gnupg
sudo apt-mark hold kubelet kubeadm kubectl

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install containerd.io
