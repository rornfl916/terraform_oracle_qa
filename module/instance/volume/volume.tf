# Define the volumes that are attached to the compute instances.
resource "oci_core_volume" "test_block_volume_paravirtualized" {
  count               = var.num_paravirtualized_volumes_per_instance
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "TestBlockParavirtualized${count.index}"
  size_in_gbs         = var.db_size
}

resource "oci_core_volume_attachment" "test_block_volume_attach_paravirtualized" {
  count           = var.num_paravirtualized_volumes_per_instance
  attachment_type = "paravirtualized"
  instance_id     = var.instance_info.id
  # var.instance_info[floor(count.index / var.num_paravirtualized_volumes_per_instance)].id
  volume_id       = oci_core_volume.test_block_volume_paravirtualized[count.index].id
  # Set this to attach the volume as read-only.
  #is_read_only = true
}