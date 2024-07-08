module "test_instance" {
    count = length(var.operating_system)
    source = "./module/instance"
    tenancy_ocid = var.tenancy_ocid
    user_ocid = var.user_ocid
    fingerprint = var.fingerprint
    private_key_path = var.private_key_path
    region = var.region
    compartment_ocid = var.compartment_ocid
    ssh_public_key = var.ssh_public_key
    ssh_private_key = var.ssh_private_key
    db_size = var.db_size
    operating_system = var.operating_system[count.index]
    operating_system_version = var.operating_system_version[count.index]
    disk_size = var.disk_size
}