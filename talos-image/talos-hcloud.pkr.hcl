# hcloud.pkr.hcl
packer {
  required_plugins {
    hcloud = {
      version = "~> 1"
      source  = "github.com/hetznercloud/hcloud"
    }
  }
}

variable "talos_version" {
  type    = string
  default = "v1.8.1"
}

variable "image_url_x86" {
  type    = string
  default = null
}

variable "server_location" {
  type    = string
  default = "fsn1"
}

locals {
  # From: https://factory.talos.dev/?arch=amd64&board=undefined&cmdline-set=true&extensions=-&extensions=siderolabs%2Fbinfmt-misc&extensions=siderolabs%2Fiscsi-tools&extensions=siderolabs%2Futil-linux-tools&platform=hcloud&secureboot=undefined&target=cloud&version=1.8.1
  image_x86 = var.image_url_x86 != null ? var.image_url_x86 : "https://factory.talos.dev/image/1da3394e6229e507d4e3d166b718cacff86435a61c4765feedd66b43ac237558/${var.talos_version}/hcloud-amd64.raw.xz"

  # Add local variables for inline shell commands
  download_image = "wget --timeout=5 --waitretry=5 --tries=5 --retry-connrefused --inet4-only -O /tmp/talos.raw.xz "

  write_image = <<-EOT
    set -ex
    echo 'Talos image loaded, writing to disk... '
    xz -d -c /tmp/talos.raw.xz | dd of=/dev/sda && sync
    echo 'done.'
  EOT

  clean_up = <<-EOT
    set -ex
    echo "Cleaning-up..."
    rm -rf /etc/ssh/ssh_host_*
  EOT
}

# Source for the Talos x86 image
source "hcloud" "talos-x86" {
  rescue       = "linux64"
  image        = "debian-11"
  location     = "${var.server_location}"
  server_type  = "cx22"
  ssh_username = "root"

  snapshot_name   = "Talos Linux ${var.talos_version} x86 by hcloud-talos"
  snapshot_labels = {
    type    = "infra",
    os      = "talos",
    version = "${var.talos_version}",
    arch    = "x86",
    creator = "hcloud-talos"
  }
}

# Build the Talos x86 snapshot
build {
  sources = ["source.hcloud.talos-x86"]

  # Download the Talos x86 image
  provisioner "shell" {
    inline = ["${local.download_image}${local.image_x86}"]
  }

  # Write the Talos x86 image to the disk
  provisioner "shell" {
    inline = [local.write_image]
  }

  # Clean-up
  provisioner "shell" {
    inline = [local.clean_up]
  }
}
