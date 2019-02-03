# Static IP addresses reservation

resource "google_compute_address" "k8s-master-ip-int" {
  name         = "k8s-master-ip-int"
  address_type = "INTERNAL"
}

resource "google_compute_address" "k8s-master-ip-ext" {
  name = "k8s-master-ip-ext"
}
