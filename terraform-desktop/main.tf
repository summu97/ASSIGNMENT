provider "google" {
  project     = "sumanth-97"
}

module "desktop-server" {
source = "/home/suasmame/terraform-desktop/modules/desktop-server"
}
