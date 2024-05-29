resource "google_project_service" "dns" {
  project = var.project_id

  service = "dns.googleapis.com"
}

resource "google_compute_network" "custom_network" {
  name           = "${terraform.workspace}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "jenkins-server" {
  name          = "${terraform.workspace}-jenkins-server-subnet"
  region        = var.jenkins-server_region
  network       = google_compute_network.custom_network.self_link
  ip_cidr_range = var.jenkins-server_cidr
}

resource "google_compute_subnetwork" "desktop-server" {
  name          = "${terraform.workspace}-desktop-server-subnet"
  region        = var.desktop-server_region
  network       = google_compute_network.custom_network.self_link
  ip_cidr_range = var.desktop-server_cidr
}
resource "google_compute_firewall" "jenkins-server" {
  name    = "${terraform.workspace}-jenkins-server-firewall"
  network = google_compute_network.custom_network.self_link

  # Allow rules
  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
  }
  
  allow {
    protocol = "icmp"
  }

  target_tags = [var.jenkins-server_network_tags] # Apply to VMs with this tag
  source_ranges = ["0.0.0.0/0"]  # Allow traffic from any source
}

resource "google_compute_firewall" "desktop-server" {
  name    = "${terraform.workspace}-desktop-server-firewall"
  network = google_compute_network.custom_network.self_link

  # Allow rules
  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
  
  allow {
    protocol = "icmp"
  }

  target_tags = [var.desktop-server_network_tags] # Apply to VMs with this tag
  source_ranges = ["0.0.0.0/0"]  # Allow traffic from any source
}

output "network_self_link" {
  value = google_compute_network.custom_network.self_link
}

output "subnetwork_self_link" {
  value = google_compute_subnetwork.jenkins-server.self_link
}
