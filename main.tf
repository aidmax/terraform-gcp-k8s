variable "project_name" {}
variable "billing_account" {}
variable "org_id" {}
variable "region" {}

provider "google" {
 region = "${var.region}"

}

resource "random_id" "id" {
 byte_length = 4
 prefix      = "${var.project_name}-"

}
