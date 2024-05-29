resource "google_compute_instance" "desktop-server" {
  name         = "${terraform.workspace}-desktop-server"
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
    network = "projects/sumanth-97/global/networks/default-vpc"
    subnetwork = "projects/sumanth-97/regions/us-west1/subnetworks/default-desktop-server-subnet"

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "default-svc@sumanth-97.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  tags = [var.name]  # Add network tags

}
