resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "7.6.8"  # Check for latest version

  namespace = "argocd"
  create_namespace = true

  values = [
    file("values-argocd.yaml")
  ]

  depends_on = [
    data.talos_cluster_health.this
  ]
}