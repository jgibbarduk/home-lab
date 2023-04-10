module "simple-instance" {
  source               = "./modules/simple-instance"

  region               = var.region
  compartment_ocid     = var.compartment_ocid
  availability_domain  = var.availability_domain
  default_fault_domain = "FAULT-DOMAIN-3"
  is_private           = false
  private_subnet_id    = module.private-vcn.private_subnet_id
  public_subnet_id     = module.private-vcn.public_subnet_id
  environment          = var.environment
  os_image_id          = "ocid1.image.oc1.uk-london-1.aaaaaaaabe4bbnwk4r72e6xytexsrranv5v6lkaae3yvudn32p36oul5ch3q" # Canonical-Ubuntu-20.04-aarch64-2022.01.18-0

  shape = "VM.Standard.A1.Flex"
  memory = "12"
  cpus = "2"
  display_name = "nomad-server-3"
  hostname_label = "nomad-server-3"

}

output "instance_ip" {
  value = module.simple-instance.instance_ip
}

module "simple-instance-2" {
  source               = "./modules/simple-instance"

  region               = var.region
  compartment_ocid     = var.compartment_ocid
  availability_domain  = var.availability_domain
  default_fault_domain = "FAULT-DOMAIN-3"
  is_private           = false
  private_subnet_id    = module.private-vcn.private_subnet_id
  public_subnet_id     = module.private-vcn.public_subnet_id
  environment          = var.environment
  os_image_id          = "ocid1.image.oc1.uk-london-1.aaaaaaaabe4bbnwk4r72e6xytexsrranv5v6lkaae3yvudn32p36oul5ch3q" # Canonical-Ubuntu-20.04-aarch64-2022.01.18-0

  shape = "VM.Standard.A1.Flex"
  memory = "12"
  cpus = "2"
  display_name = "nomad-client-3"
  hostname_label = "nomad-client-3"
}

output "instance_ip_2" {
  value = module.simple-instance-2.instance_ip
}