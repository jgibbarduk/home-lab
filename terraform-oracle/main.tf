
# module "nat-instance" {
#   region              = var.region
#   compartment_ocid    = var.compartment_ocid
#   availability_domain = var.availability_domain
#   vcn_id              = module.private-vcn.vcn_id
#   private_subnet_id   = module.private-vcn.private_subnet_id
#   public_subnet_id    = module.private-vcn.public_subnet_id
#   environment         = var.environment
#   source              = "../nat-instance"
# }

# output "nat_instance_id" {
#   value = module.nat-instance.nat_instance_id
# }

# output "nat_instance_public_ip" {
#   value = module.nat-instance.nat_instance_public_ip
# }



# module "instance-pool" {
#   region              = var.region
#   compartment_ocid    = var.compartment_ocid
#   availability_domain = var.availability_domain
#   is_private          = true
#   private_subnet_id   = module.private-vcn.private_subnet_id
#   public_subnet_id    = module.private-vcn.public_subnet_id
#   public_subnet_cidr  = module.private-vcn.public_subnet_cidr
#   environment         = var.environment
#   source              = "../instance-pool"
# }

# output "instance_pool_ips" {
#   value = module.instance-pool.instances_ips
# }

# output "instance_pool_id" {
#   value = module.instance-pool.instance_pool_id
# }

# output "instance_pool_size" {
#   value = module.instance-pool.instance_pool_size
# }


# module "load-balancer" {
#   region             = var.region
#   compartment_ocid   = var.compartment_ocid
#   is_private         = false
#   instance_pool_id   = module.instance-pool.instance_pool_id
#   instance_pool_size = module.instance-pool.instance_pool_size
#   vcn_id             = module.private-vcn.vcn_id
#   private_subnet_id  = module.private-vcn.private_subnet_id
#   public_subnet_id   = module.private-vcn.public_subnet_id
#   environment        = var.environment
#   source             = "../load-balancer"
# }

# output "lb_ip" {
#   value = module.load-balancer.lb_ip
# }

# module "network-load-balancer" {
#   region              = var.region
#   compartment_ocid    = var.compartment_ocid
#   is_private          = true
#   instance_pool_id    = module.instance-pool.instance_pool_id
#   instance_pool_size  = module.instance-pool.instance_pool_size
#   vcn_id              = module.private-vcn.vcn_id
#   private_subnet_id   = module.private-vcn.private_subnet_id
#   public_subnet_id    = module.private-vcn.public_subnet_id
#   environment         = var.environment
#   source              = "../network-load-balancer"
# }

# output "internal_lb_ip" {
#   value = module.network-load-balancer.lb_ip
# }