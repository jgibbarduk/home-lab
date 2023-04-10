module "private-vcn" {
  region            = var.region
  compartment_ocid  = var.compartment_ocid
  my_public_ip_cidr = "31.124.209.154/32"
  environment       = var.environment
  source            = "./modules/private-vcn"
}

output "vcn_id" {
  value = module.private-vcn.vcn_id
}

output "public_subnet_id" {
  value = module.private-vcn.public_subnet_id
}

output "private_subnet_id" {
  value = module.private-vcn.private_subnet_id
}

output "security_list_id" {
  value = module.private-vcn.security_list_id
}

output "public_subnet_cidr" {
  value = module.private-vcn.public_subnet_cidr
}