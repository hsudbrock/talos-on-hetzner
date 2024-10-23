terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.48.1"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.6.1"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}


