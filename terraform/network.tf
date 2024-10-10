# The external IPv4 for our control plane
resource "hcloud_primary_ip" "main" {
  name          = "the-ip"
  datacenter    = "nbg1-dc3"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
}