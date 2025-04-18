# k3s CI/CD Environment Setup

This repository provides a scaffold to deploy a lightweight Kubernetes cluster using k3s and set up a CI/CD environment with:
- Kubernetes Dashboard
- Argo CD (GitOps)
- Argo Workflows

## Directory Structure

- `scripts/`: Installation and deployment scripts
- `values/`: Helm values files for each component
- `resources/`: Kubernetes manifests for RBAC and storage configuration
- `apps/`: Argo CD Application manifests (GitOps)
- `workflows/`: Example Argo Workflows pipelines

## Usage

1. Install k3s (must run as root):
   ```bash
   sudo scripts/install-k3s.sh
   ```
   After installation, set your kubeconfig:
   ```bash
   export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
   ```

2. Install and configure Helm:
   ```bash
   scripts/setup-helm.sh
   ```

3. Update Argo CD Application manifests:
   - Edit `apps/dashboard-app.yaml` and `apps/argo-workflows-app.yaml`
   - Replace `<YOUR_REPO_URL>` with the URL of this Git repository.

4. Deploy CI/CD environment:
   ```bash
   scripts/deploy-cicd.sh
   ```

5. Access services:
   - **Kubernetes Dashboard**  
     ```bash
     kubectl -n kubernetes-dashboard port-forward svc/dashboard 8443:443
     ```  
     Access at `https://localhost:8443`

   - **Argo CD**  
     ```bash
     kubectl -n argocd port-forward svc/argo-cd-server 8080:80
     ```  
     Access at `http://localhost:8080`  
     Admin password:  
     ```bash
     kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
     ```

6. Run example workflows:
   ```bash
   kubectl create -f workflows/hello-world.yaml -n argo-workflows
   kubectl create -f workflows/ci-pipeline.yaml -n argo-workflows
   ```