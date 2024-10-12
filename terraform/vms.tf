# The SSH key to use on the VMs - not really needed since Talos blocks SSH, but avoids info from Hetzner that no SSH key was provided
resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "hcloud_ssh_key" "this" {
  name       = "Default SSH key"
  public_key = tls_private_key.this.public_key_openssh
}

# The talos image that we have pre-created on our Hetzner account
data "hcloud_image" "talos_image" {
  with_selector = "os=talos,version=v1.8.1"
  most_recent = true
}

# For now, a single controlplane node
resource "hcloud_server" "controlplane" {
  name        = "controlplane-server"
  server_type = "cx22" # 2 vCPUs, 4GB RAM, 40GB SSD, 3.29/Month, https://docs.hetzner.com/cloud/servers/overview/#shared-vcpu
  image       = data.hcloud_image.talos_image.id
  location    = "nbg1" # Nuernberg
  public_net {
    ipv4         = hcloud_primary_ip.main.id
    ipv4_enabled = true
    ipv6_enabled = false
  }
  user_data   = data.talos_machine_configuration.controlplane.machine_configuration
  ssh_keys = [hcloud_ssh_key.this.id]
}
