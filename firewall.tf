data "google_compute_network" "default" {
  name = "default"
}

data "google_compute_subnetwork" "subnetworks" {
  name   = "${data.google_compute_network.default.name}"
  region = "${var.region}"

  // In case of we need all internal subnetworks
  // count = "${length(data.google_compute_network.default.subnetworks_self_links)}"
  // region = "${element(split("/", data.google_compute_network.default.subnetworks_self_links[count.index]), 8)}"
}

# Override default network allow rules

resource "google_compute_firewall" "default-deny-ssh" {
  name        = "default-deny-ssh"
  network     = "default"
  description = "deny SSH from anywhere"
  priority    = "65533"

  deny {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default-deny-rdp" {
  name        = "default-deny-rdp"
  network     = "default"
  description = "deny RDP from anywhere"
  priority    = "65533"

  deny {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default-deny-icmp" {
  name        = "default-deny-icmp"
  network     = "default"
  description = "deny ICMP from anywhere"
  priority    = "65533"

  deny {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "default-allow-internal-override" {
  name        = "default-allow-internal-override"
  network     = "default"
  description = "Allow internal traffic on the default network"
  priority    = "65533"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "${data.google_compute_subnetwork.subnetworks.*.ip_cidr_range}",
  ]
}

# Allow remote k8s admin connections

resource "google_compute_firewall" "remote-k8s-admin" {
  name        = "remote-k8s-admin"
  network     = "default"
  description = "ACL to remote k8s connection"
  direction   = "INGRESS"
  priority    = "1000"

  allow {
    protocol = "tcp"
    ports    = ["22", "6443", "443"]
  }

  source_ranges = ["${var.admin_wan_ip}"]

  target_tags = ["k8s-master", "k8s-node"]
}
