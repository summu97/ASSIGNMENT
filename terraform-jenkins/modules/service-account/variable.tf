variable "project_id" {
description = "sbjds"
type = string
default = "sumanth-97"
}

variable "roles" {
  default = [
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin",
    "roles/iam.serviceAccountUser",
    "roles/compute.instanceAdmin"
  ]
}
