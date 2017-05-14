// Module specific variables
variable "role" {
  description = "The role of the instance"
  default = "" 
}

variable "env" {
  description = "The environment this instance will exist in"
  default = "" 
}

variable "vpc" {
  description = "The VPC this instance is attached to"
  default = "" 
}

variable "orchestration" {
  description = "Will this instance be managed by orchestration"
  default     = "false"
}

variable "name" {}
variable "key_name" {}

variable "load_balancers" {
  default = [] 
}

variable "security_groups" {
  default = []
}

variable "availability_zones" {
  default = []
}

variable "vpc_zone_identifier" {
  type = "list" 
  default = []
 
}


variable "instance_type" {}

variable "count" {
  default = "dummy"
}


variable "min_size" {}
variable "max_size" {}
variable "enable_monitoring" {
default = "false"
}
variable "force_delete" {
default = "false"
}
variable "image_id" {}
variable "desired_capacity" {}
variable "user_data" {}

variable "health_check_type" {
  default = "ELB"
}
variable "iam_policy" {}

variable "cluster_name" { default = "" }

variable "block_device" {
  type    = "map"
  default = { type = "none" }
}
