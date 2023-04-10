variable "compartment_ocid" {

}

variable "region" {

}

variable "availability_domain" {

}

variable "PATH_TO_PUBLIC_KEY" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to your public key"
}

variable "environment" {
  type = string
}

variable "is_private" {
  type    = bool
  default = false
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "default_fault_domain" {
  default = "FAULT-DOMAIN-3"
}

variable "os_image_id" {
  default = "ocid1.image.oc1.uk-london-1.aaaaaaaacd6wvghqqeocouaahlveplsl4bkutztyz6rstu5bag6limxr5rxa" # Canonical-Ubuntu-20.04-aarch64-2022.01.18-0
}

variable "shape" {
  default = "VM.Standard.A1.Flex"
  type    = string
}

variable "memory" {
  default = "24"
  type    = string
}

variable "cpus" {
  default = "4"
  type    = string
}

variable "display_name" {
  default = "Ubuntu Instance"
  type    = string
}

variable "hostname_label" {
  default = "ubuntu-instance"
  type = string
}

variable "baseline_ocpu" {
  default = "BASELINE_1_1"
  type    = string
}