# output "instance_private_ips" {
#   value = [oci_core_instance.test_instance.*.private_ip]
# }

output "instance_public_ips" {
  value = oci_core_instance.test_instance.public_ip
}

output "os_id" {
  value = module.OS.os_id
}

output "os_name" {
  value = module.OS.os_name
}

output "instance_name" {
  value = oci_core_instance.test_instance.display_name
}