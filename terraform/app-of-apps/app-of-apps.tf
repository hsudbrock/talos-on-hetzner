# This installs the argocd application that targets my app-of-apps parent app
resource "kubernetes_manifest" "parent_app" {
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

