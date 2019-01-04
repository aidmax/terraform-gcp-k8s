resource "google_compute_project_metadata" "default" {
  metadata {
    ssh-keys = "${file("${var.ssh_public_key}")}"
  }
}
