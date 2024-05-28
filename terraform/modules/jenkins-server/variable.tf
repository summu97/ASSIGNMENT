variable "machine_type" {
type = string
default = "n2-standard-2"
}

variable "name" {
type = string
default = "jenkins-server"
}

variable "zone" {
type = string
default = "us-west1-a"
}

variable "image" {
type = string
default = "ubuntu-os-cloud/ubuntu-2004-lts"
}
