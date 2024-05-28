module "networking" {
source = "/home/suasmame/terraform/modules/networking"
}

module "service-account" {
source = "/home/suasmame/terraform/modules/service-account"
}

resource "google_compute_instance" "bastion" {
  name         = "${terraform.workspace}-jenkins-server"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      labels = {
        my_label = "${terraform.workspace}"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = module.networking.network_self_link
    subnetwork = module.networking.subnetwork_self_link

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = module.service-account.svc_email
    scopes = ["cloud-platform"]
  }

  tags = [var.name]  # Add network tags

}
