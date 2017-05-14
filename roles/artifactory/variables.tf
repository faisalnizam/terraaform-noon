variable "name" {}
variable "region" {}
variable "profile" {}
variable "ami_id" {}
variable "key_name" {}
variable "instance_type" {}
variable "vpc_id" {}
variable "vpc" {}
variable "min_size" {}
variable "max_size" {}
variable "total_instances" {}
variable "health_check_type" {}
variable "monitoring" {}
variable "delete" {}
variable "tag_product" {}
variable "tag_purpose" {}
variable "cluster_name" {}
variable "hostname" {}
variable "ssl_certificate_id" {}
variable "domain" {}
variable "file_name" {}
variable "archive_link" {}
variable "from_port" {}
variable "to_port" {}
variable "health_check_port" {}

variable "zone_id" {
  default = "Z3I91H6QNBJ8DO"
}

variable "dns_address" {}
variable "record_type" {}

variable "records" {
  default = []
}

variable "subnets" {
  default = []
}

variable "artifactory" {
  default = {
    "extra_user_data" = ""
    "key_name"        = ""
    "ami"             = ""
    "instance_type"   = ""
  }
}

variable "count" {
  default = 0
}

variable "availability_zones" {
  default = []
}

variable "vpc_zone_identifier" {
  default = []
}

variable "vpc_zone_identifier_ec2" {
  default = []
}

#variable "load_balancers" {
#  default = ""
#}

variable "security_groups" {
  default = []
}

variable "cidr_blocks" {
  default = []
}
