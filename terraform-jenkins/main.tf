provider "google" {
  project     = "sumanth-97"
}

module "jenkins-server" {
source = "/home/suasmame/terraform-jenkins/modules/jenkins-server"
}
