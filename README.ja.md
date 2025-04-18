# k3s CI/CD 環境セットアップ

このリポジトリは、k3s を使用して軽量な Kubernetes クラスタを構築し、以下の CI/CD 環境をセットアップするためのひな形を提供します。
- Kubernetes Dashboard
- Argo CD (GitOps)
- Argo Workflows

## ディレクトリ構成

- `scripts/`: インストールおよびデプロイ用スクリプト
- `values/`: 各コンポーネントの Helm values ファイル
- `resources/`: RBAC やストレージ設定用の Kubernetes マニフェスト
- `apps/`: Argo CD Application マニフェスト (GitOps 管理用)
- `workflows/`: Argo Workflows のサンプルパイプライン

## 前提条件

- Linux 環境 (root 権限が必要)
- curl, bash
- Docker イメージをプルできるネットワーク

## 使い方

1. k3s のインストール (root 権限で実行)
   ```bash
   sudo scripts/install-k3s.sh
   ```
   インストール後、kubeconfig を設定:
   ```bash
   export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
   ```

2. Helm のインストールおよびリポジトリ登録
   ```bash
   scripts/setup-helm.sh
   ```

3. Argo CD Application マニフェストの更新
   - `apps/dashboard-app.yaml` と `apps/argo-workflows-app.yaml` をテキストエディタで開く
   - `<YOUR_REPO_URL>` をこのリポジトリの URL に置き換える

4. CI/CD 環境のデプロイ
   ```bash
   scripts/deploy-cicd.sh
   ```

5. サービスへのアクセス
   - **Kubernetes Dashboard**  
     ```bash
     kubectl -n kubernetes-dashboard port-forward svc/dashboard 8443:443
     ```  
     ブラウザで `https://localhost:8443` にアクセス

   - **Argo CD**  
     ```bash
     kubectl -n argocd port-forward svc/argo-cd-server 8080:80
     ```  
     ブラウザで `http://localhost:8080` にアクセス
     管理者パスワード取得:
     ```bash
     kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
     ```

6. サンプルワークフローの実行
   ```bash
   kubectl create -f workflows/hello-world.yaml -n argo-workflows
   kubectl create -f workflows/ci-pipeline.yaml -n argo-workflows
   ```

## 補足

- GitOps の管理下に置くため、Argo CD のアプリケーションは `apps/` ディレクトリのマニフェストを参照します。
- 必要に応じて `values/` ディレクトリ内の Helm values を調整してください。