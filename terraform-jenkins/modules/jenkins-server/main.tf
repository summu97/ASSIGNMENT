module "networking" {
source = "/home/suasmame/terraform-jenkins/modules/networking"
}

module "service-account" {
source = "/home/suasmame/terraform-jenkins/modules/service-account"
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

  metadata_startup_script = <<-EOF
  #! /bin/bash
    sudo apt-get update
    sudo apt install git -y
    sudo apt install -y openjdk-17-jre wget vim

    # Install Jenkins
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins -y
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    # Install Maven
    wget https://apache.osuosl.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz
    tar xzvf apache-maven-3.9.5-bin.tar.gz
    sudo mv apache-maven-3.9.5 /opt
    # Set environment variables
    echo 'export M2_HOME=/opt/apache-maven-3.9.5' >> ~/.bashrc
    echo 'export PATH=$M2_HOME/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    # Install Ansible
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible
    #source ~/.bashrc
  EOF

}
