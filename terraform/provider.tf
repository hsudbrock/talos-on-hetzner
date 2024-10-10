terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.48.1"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.6.0"
    }

    local = {
      source = "hashicorp/local"
      version = "2.5.2"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}
