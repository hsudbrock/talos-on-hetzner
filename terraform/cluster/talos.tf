resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = "geronimo"
  machine_type     = "controlplane"
  cluster_endpoint = "https://${hcloud_primary_ip.main.ip_address}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version = var.talos_version
  docs             = false
  examples         = false
}

data "talos_machine_configuration" "worker" {
  cluster_name     = "geronimo"
  machine_type     = "worker"
  cluster_endpoint = "https://${hcloud_primary_ip.main.ip_address}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version = var.talos_version
  docs             = false
  examples         = false
}

data "talos_client_configuration" "this" {
  cluster_name         = "geronimo"
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [hcloud_primary_ip.main.ip_address]
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = hcloud_primary_ip.main.ip_address
  node                 = hcloud_primary_ip.main.ip_address
  depends_on = [
    hcloud_server.controlplane
  ]
}

data "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = hcloud_primary_ip.main.ip_address
  depends_on = [
    talos_machine_bootstrap.this
  ]
}

data "talos_cluster_health" "this" {
  depends_on = [
    talos_machine_bootstrap.this
  ]
  client_configuration = talos_machine_secrets.this.client_configuration
  control_plane_nodes = [hcloud_primary_ip.main.ip_address]
  endpoints = [hcloud_primary_ip.main.ip_address]
  worker_nodes = [hcloud_server.worker.ipv4_address]
}