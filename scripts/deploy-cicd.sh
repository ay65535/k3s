#!/usr/bin/env bash
set -euo pipefail

echo "Creating namespaces..."
kubectl create namespace kubernetes-dashboard || true
kubectl create namespace argocd || true
kubectl create namespace argo-workflows || true

echo "Applying RBAC resources..."
kubectl apply -f resources/dashboard-rbac.yaml
kubectl apply -f resources/argo-workflows-rbac.yaml

echo "Installing or updating Helm charts..."
helm upgrade --install dashboard kubernetes-dashboard/kubernetes-dashboard \
  -n kubernetes-dashboard -f values/dashboard.yaml
helm upgrade --install argo-cd argo/argo-cd \
  -n argocd -f values/argocd.yaml
helm upgrade --install argo-workflows argo/argo-workflows \
  -n argo-workflows -f values/argo-workflows.yaml

echo "Waiting for Argo CD server to be ready..."
kubectl wait --for=condition=available deployment/argo-cd-argocd-server \
  -n argocd --timeout=120s

echo "Applying Argo CD Applications (GitOps)..."
kubectl apply -f apps/dashboard-app.yaml
kubectl apply -f apps/argo-workflows-app.yaml

echo "CI/CD environment deployment completed."
