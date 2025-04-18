#!/usr/bin/env bash
set -euo pipefail
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root."
  exit 1
fi

echo "Installing k3s..."
curl -sfL https://get.k3s.io | sh -
echo "k3s installation completed."
echo "Export KUBECONFIG with:"
echo "  export KUBECONFIG=/etc/rancher/k3s/k3s.yaml"

echo "You can also view cluster info with:"
echo "  kubectl get nodes"