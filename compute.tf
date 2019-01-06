data "google_compute_image" "k8s" {
  family    = "k8s"
}

resource "google_compute_instance" "k8s-master" {
    name         = "k8s-master"
    machine_type = "n1-standard-1"
    zone         = "${var.zone}"

    tags = ["k8s-master"]

    boot_disk {
        initialize_params {
            image = "${data.google_compute_image.k8s.self_link}"
            size  = 20
            type  = "pd-standard"
        }
    }

    network_interface {
        network            = "default"
        //subnetwork_project = "${var.subnetwork_project}"

        access_config {
            // Ephemeral IP
        }
    }

    //service_account {
     //  scopes = ["${var.sa_stg_write}"]
    //}
}

