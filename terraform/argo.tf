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

# This installs the argocd application that targets my app-of-apps parent app
resource "kubernetes_manifest" "parent_app" {
  depends_on = [
    helm_release.argocd
  ]
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "parent-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/hsudbrock/talos-on-hetzner.git"
        targetRevision = "main"
        path           = "argo-app-of-apps/parent-app"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}

