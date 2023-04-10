# terraform {
#   required_version = ">= 0.12.6"
#   required_providers {
#     oci = {
#       version = ">= 4.100.0"
#       source = "oracle/oci"
#     }
#   }
# }

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}
