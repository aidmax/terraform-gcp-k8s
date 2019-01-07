// Project related veriables

variable "project"{
  description = "Project to provision"
}

variable "region" {
  description = "Region to provision the resources into."
}

variable "zone" {
  description = "Zone to provision the resources into."
}

variable "ssh_public_key" {
  description = "Project wide ssh access key"
}

variable "ssh_user" {
  description = "Project wide ssh access username"
}

variable "is_preemptible" {
  description = "Short-lived VM instance, more affordable, last for up to 24 hours"
  default = true
}


