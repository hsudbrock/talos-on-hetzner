terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"  # Specify the version you need
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "../cluster/kubeconfig"
  }
}

