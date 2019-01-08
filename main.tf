terraform {
  required_version = ">= 0.11.10"
}

provider "google" {
  version = ">= 1.20.0"
  project = "${var.project}"
  region  = "${var.region}"
  zone    = "${var.zone}"
}

provider "external" {
  version = "1.0.0"
}

resource "google_compute_project_metadata" "default" {
  metadata {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_public_key}")}"
  }
}
