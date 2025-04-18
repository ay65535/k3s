指示: k3sでkubernetesを構築し、CI/CD環境を構築してください。

Kubernetesディストリ: k3s

デプロイするPod:
- dashboard
- argo cd
- argo workflows

方針:
- k3sのクラスタを作成するシェルスクリプトを作成して
- helmを使用して、 values/ ディレクトリに helm の value yaml を配置して
- Podをデプロイする用のyamlは apps/ に配置して
- 認証情報やストレージ情報のyamlは resources/ に配置して
- argo workflows の パイプラインは workflows/ に配置して
- argo cd でこのクラスタを GitOps / IaC の考え方で管理して
