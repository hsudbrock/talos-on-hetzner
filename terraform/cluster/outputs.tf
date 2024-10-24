output "kubeconfig" {
  value     = data.talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}

output "talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "control_plane_ip" {
  value = hcloud_primary_ip.main.ip_address
}

resource "local_file" "kubeconfig" {
  content = data.talos_cluster_kubeconfig.this.kubeconfig_raw
  filename = "kubeconfig"
  file_permission = "0700"
}

resource "local_file" "talosconfig" {
  content = data.talos_client_configuration.this.talos_config
  filename = "talosconfig"
  file_permission = "0700"
}