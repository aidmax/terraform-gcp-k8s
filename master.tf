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

    provisioner "remote-exec" {
      inline = [
        "set -e",
        "sudo kubeadm init",
        "mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config",
        "kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')\"",
      ]

      connection {
        user    = "${var.ssh_user}"
        timeout = "300s"
      }
    }
}

data "external" "kubeadm_join" {

  program = ["${path.module}/scripts/kubeadm-token.sh"]

  query = {
    host     = "${google_compute_instance.k8s-master.network_interface.0.access_config.0.nat_ip}"
    ssh_user = "${var.ssh_user}"
    key      = "${var.ssh_private_key}"
  }

  depends_on = ["google_compute_instance.k8s-master"]
}
