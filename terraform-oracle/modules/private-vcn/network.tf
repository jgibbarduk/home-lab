resource "oci_core_vcn" "default_oci_core_vcn" {
  cidr_block     = var.oci_core_vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "Default OCI core vcn"
  dns_label      = var.oci_core_vcn_dns_label
  freeform_tags  = local.tags
}

resource "oci_core_subnet" "default_oci_core_subnet10" {
  cidr_block        = var.oci_core_subnet_cidr10
  compartment_id    = var.compartment_ocid
  display_name      = "${var.oci_core_subnet_cidr10} (default) PUBLIC OCI core subnet"
  dns_label         = var.oci_core_subnet_dns_label10
  route_table_id    = oci_core_vcn.default_oci_core_vcn.default_route_table_id
  vcn_id            = oci_core_vcn.default_oci_core_vcn.id
  security_list_ids = [oci_core_default_security_list.default_security_list.id]
  freeform_tags     = local.tags
}

resource "oci_core_subnet" "oci_core_subnet11" {
  cidr_block                 = var.oci_core_subnet_cidr11
  compartment_id             = var.compartment_ocid
  display_name               = "${var.oci_core_subnet_cidr11} PRIVATE OCI core subnet"
  dns_label                  = var.oci_core_subnet_dns_label11
  vcn_id                     = oci_core_vcn.default_oci_core_vcn.id
  prohibit_public_ip_on_vnic = true
  prohibit_internet_ingress  = true
  security_list_ids          = [oci_core_default_security_list.default_security_list.id]
  freeform_tags              = local.tags
}

resource "oci_core_internet_gateway" "default_oci_core_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "Internet Gateway Default OCI core vcn"
  enabled        = "true"
  vcn_id         = oci_core_vcn.default_oci_core_vcn.id
  freeform_tags  = local.tags
}

resource "oci_core_default_route_table" "default_oci_core_default_route_table" {
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.default_oci_core_internet_gateway.id
  }
  manage_default_resource_id = oci_core_vcn.default_oci_core_vcn.default_route_table_id
}