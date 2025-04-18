#!/usr/bin/env bash
set -euo pipefail

if ! command -v helm &>/dev/null; then
  echo "Installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

echo "Adding Helm repositories..."
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update