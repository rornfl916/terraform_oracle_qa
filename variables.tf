variable "tenancy_ocid" {
  default = "ocid1.tenancy.oc1..aa"
}

variable "user_ocid" {
  default = "ocid1.user.oc1..aa"
}

variable "fingerprint" {
  default = ""
}

variable "private_key_path" {
  default = "./-05-17-05-57.pem"
}

variable "region" {
  default = "ap-seoul-1"
}

variable "compartment_ocid" {
  default = "ocid1.compartment.oc1..aa"
}

variable "ssh_public_key" {
  default = ""
}

variable "ssh_private_key" {
  default = <<EOF
  -----BEGIN RSA PRIVATE KEY-----

-----END RSA PRIVATE KEY-----
EOF
}

variable "db_size" {
  default = 50
}

variable "operating_system" {
   default = [
    "CentOS",
    "CentOS",
    "Oracle Linux",
    "Oracle Linux",
    "Oracle Linux",
    "Canonical Ubuntu",
    "Canonical Ubuntu",
    "Windows",
    "Windows",
    "Windows",
    "Windows",
  ]
}

variable "operating_system_version" {
  default = [
    "7",
    "8 Stream",
    "6.10",
    "7.9",
    "8",
    "20.04",
    "22.04",
    "Server 2012 R2 Standard",
    "Server 2016 Standard",
    "Server 2019 Standard",
    "Server 2022 Standard",
  ]
}

variable "disk_size" {
  default = "50" # size in GBs
}