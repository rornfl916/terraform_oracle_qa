output "os_id" {
  value = local.os_ids.0
}

output "os_name" {
  value = local.os_names.0
}

locals {
  os_ids = [for i in data.oci_core_images.OS_image.images: "${i.id}" if !(strcontains(i.display_name, "aarch64")) && !(strcontains(i.display_name, "GPU")) && !(strcontains(i.display_name, "B1"))]
}

locals {
  os_names = [for i in data.oci_core_images.OS_image.images: "${i.display_name}" if !(strcontains(i.display_name, "aarch64")) && !(strcontains(i.display_name, "GPU")) && !(strcontains(i.display_name, "B1"))]
}