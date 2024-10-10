output "kubeconfig" {
  value     = data.talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}

output "talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

resource "local_file" "kubeconfig" {
  content = data.talos_cluster_kubeconfig.this.kubeconfig_raw
  filename = "kubeconfig"
}

resource "local_file" "talosconfig" {
  content = data.talos_client_configuration.this.talos_config
  filename = "talosconfig"
}