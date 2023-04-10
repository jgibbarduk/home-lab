variable "compartment_ocid" {
  type = string
}

variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "region" {
  default = "uk-london-1"
}

variable "environment" {
  default = "home-lab"
}

variable "availability_domain" {
  default = "OPVH:UK-LONDON-1-AD-1"
}