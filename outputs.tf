output "image_id" {
  value = "${data.google_compute_image.k8s.id}"
}

output "image_self_link" {
  value = "${data.google_compute_image.k8s.self_link}"
}

output "k8s-master-ip" {
  value = ["${google_compute_instance.k8s-master.network_interface.0.access_config.0.nat_ip}"]
}

output "k8s-node-ip" {
  value = ["${google_compute_instance.k8s-node.*.network_interface.0.access_config.0.nat_ip}"]
}

output "kubeadm_join_command" {
  value = "${data.external.kubeadm_join.result["command"]}"
}
