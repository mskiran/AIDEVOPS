#!/bin/bash
# setup_master.sh - Kubernetes Master Node Setup

set -e

# Perform apt update, upgrade, and autoremove before proceeding
echo "[INFO] Running apt update, upgrade, and autoremove..."
sudo apt update
sudo apt list --upgradable
sudo apt upgrade -y
sudo apt autoremove -y

echo "[INFO] Installing Kubernetes components..."

# Disable swap and make it permanent
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "[INFO] Configuring networking..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

# Install dependencies for Kubernetes
sudo apt install -y apt-transport-https ca-certificates curl

# Install containerd
sudo apt install -y containerd
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# Set up Kubernetes APT repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes components
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "[INFO] Checking if Kubernetes cluster is already initialized..."
if [ -f /etc/kubernetes/admin.conf ]; then
    echo "[INFO] Kubernetes master is already initialized. Skipping initialization."
else
    echo "[INFO] Initializing Kubernetes Master..."
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    # Apply Calico network plugin
    kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

    echo "[INFO] Waiting 3 minutes for the master to stabilize..."
    sleep 180

    # Save the join command for worker nodes
    kubeadm token create --print-join-command > /tmp/kubeadm_join.sh
    echo "[INFO] Join command saved to /tmp/kubeadm_join.sh"

    # Optionally, copy this file to worker nodes manually or via scp
    scp /tmp/kubeadm_join.sh kiran@node:/tmp/
fi

echo "[INFO] Master node setup is complete! Run setup_worker.sh on the worker node."

