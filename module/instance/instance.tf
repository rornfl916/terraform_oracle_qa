module "OS" {
  source = "./image"
  compartment_ocid = var.compartment_ocid
  operating_system = var.operating_system
  operating_system_version = var.operating_system_version
}

resource "oci_core_vcn" "test_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "TestVcn"
  dns_label      = "testvcn"
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "TestInternetGateway"
  vcn_id         = oci_core_vcn.test_vcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.test_vcn.default_route_table_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}

resource "oci_core_subnet" "test_subnet" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.1.20.0/24"
  display_name        = "TestSubnet"
  dns_label           = "testsubnet"
  security_list_ids   = [oci_core_vcn.test_vcn.default_security_list_id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.test_vcn.id
  route_table_id      = oci_core_vcn.test_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.test_vcn.default_dhcp_options_id
}

resource "oci_core_instance" "test_instance" {
  availability_domain        = data.oci_identity_availability_domain.ad.name
  compartment_id             = var.compartment_ocid
  display_name               = "${var.operating_system} ${var.operating_system_version}"
  shape                      = local.shapes.0

  # shape_config {
  #   ocpus = var.instance_ocpus
  #   memory_in_gbs = var.instance_shape_config_memory_in_gbs
  # }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.test_subnet.id
    display_name              = "Primaryvnic"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "testinstance"
  }

  source_details {
    source_type = "image"

    # See https://docs.oracle.com/en-us/iaas/Content/Compute/References/images.htm
    source_id = module.OS.os_id
  }

  # Apply the following flag only if you wish to preserve the attached boot volume upon destroying this instance
  # Setting this and destroying the instance will result in a boot volume that should be managed outside of this config.
  # When changing this value, make sure to run 'terraform apply' so that it takes effect before the resource is destroyed.
  #preserve_boot_volume = true

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("./userdata/bootstrap"))
  }

    timeouts {
    create = "60m"
  }
}

# Data section
#############################################################################################
#############################################################################################
#############################################################################################

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_core_image_shapes" "shapes" {
  image_id = module.OS.os_id
}

locals {
  shapes = [for i in data.oci_core_image_shapes.shapes.image_shape_compatibilities: "${i.shape}" if strcontains(i.shape, "VM.Standard2")]
}

locals {
  instance_info = oci_core_instance.test_instance
}

module "os_vol" {
  source = "./volume"
  compartment_ocid = var.compartment_ocid
  tenancy_ocid = var.tenancy_ocid
  instance_info = local.instance_info
}