output "instance_info" {
  value = [for i in module.test_instance: [i.instance_name, i.instance_public_ips, i.os_name, i.os_id] ]
}