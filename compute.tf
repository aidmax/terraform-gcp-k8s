data "google_compute_image" "k8s" {
  family    = "k8s"
}

resource "google_compute_instance" "k8s-master" {
    count = 1

    name         = "k8s-master-${count.index}"
    machine_type = "n1-standard-2"
    zone         = "${var.zone}"

    tags = ["k8s-master"]
    
    allow_stopping_for_update = "true"
    can_ip_forward = "true"

    boot_disk {
        initialize_params {
            image = "${data.google_compute_image.k8s.self_link}"
            size  = 20
            type  = "pd-standard"
        }
    }

    network_interface {
        network            = "default"

        access_config {
            // Ephemeral IP
        }
    }
    
    scheduling {
        preemptible       = "${var.is_preemptible}"
        automatic_restart = false
    }

}

resource "google_compute_instance" "k8s-node" {
    count = 2

    name         = "k8s-node-${count.index}"
    machine_type = "f1-micro"
    zone         = "${var.zone}"

    tags = ["k8s-master"]
    
    allow_stopping_for_update = "true"
    can_ip_forward = "true"

    boot_disk {
        initialize_params {
            image = "${data.google_compute_image.k8s.self_link}"
            size  = 10
            type  = "pd-standard"
        }
    }

    network_interface {
        network            = "default"

        access_config {
            // Ephemeral IP
        }
    }

    scheduling {
        preemptible       = "${var.is_preemptible}"
        automatic_restart = false
    }
}
