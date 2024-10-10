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
}
