resource "google_compute_project_metadata" "default" {
  metadata {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_public_key}")}"
  }
}
