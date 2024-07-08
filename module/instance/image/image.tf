data "oci_core_images" "OS_image" {
  compartment_id = var.compartment_ocid

  operating_system = var.operating_system
  operating_system_version = var.operating_system_version
}