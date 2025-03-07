#!/bin/bash
# setup_worker.sh - Kubernetes Worker Node Setup

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

# Get join command from master node (copy from /tmp/kubeadm_join.sh)
echo "[INFO] Joining the worker node to the cluster..."

if [ -f /tmp/kubeadm_join.sh ]; then
    echo "[INFO] Found the join command. Executing..."
    sudo bash /tmp/kubeadm_join.sh

    if [ $? -eq 0 ]; then
        echo "[INFO] Worker node successfully joined to the Kubernetes cluster!"
    else
        echo "[ERROR] Failed to join the worker node to the cluster."
        exit 1
    fi
else
    echo "[ERROR] Could not find join command. Please ensure the file /tmp/kubeadm_join.sh exists."
    exit 1
fi

