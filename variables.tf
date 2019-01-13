// Project related veriables

variable "project" {
  description = "Project to provision"
}

variable "region" {
  description = "Region to provision the resources into."
}

variable "zone" {
  description = "Zone to provision the resources into."
}

variable "ssh_public_key" {
  description = "Project wide public ssh access key"
}

variable "ssh_private_key" {
  description = "Project wide private ssh access key"
}

variable "ssh_user" {
  description = "Project wide ssh access username"
}

variable "admin_wan_ip" {
  description = "External IP of k8s admin"
}

variable "nodes" {
  description = "How many worker nodes should be created"
  default     = 2
}

variable "is_preemptible" {
  description = "Short-lived VM instance, more affordable, last for up to 24 hours"
  default     = true
}
