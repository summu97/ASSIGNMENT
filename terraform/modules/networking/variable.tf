variable "project_id" {
type = string
default = "sumanth-97"
}

variable "jenkins-server_region" {
type = string
default = "us-west1"
}

variable "jenkins-server_cidr" {
type = string
default = "10.0.1.0/24"
}

variable "desktop-server_region" {
type = string
default = "us-west1"
}

variable "desktop-server_cidr" {
type = string
default = "10.0.2.0/24"
}

variable "jenkins-server_network_tags" {
type = string
default = "jenkins-server"
}

variable "desktop-server_network_tags" {
type = string
default = "desktop-server"
}
