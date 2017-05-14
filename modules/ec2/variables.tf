// Module specific variables

variable "root_block_size" {
  default = 50
}

variable "root_delete_on_termination" {
  default = true
}

variable "user_data" {
  default = ""
}

variable "role" {
  description = "The role of the instance"
}

variable "env" {
  description = "The environment this instance will exist in"
}

variable "vpc" {
  description = "The VPC this instance is attached to"
}

variable "orchestration" {
  description = "Will this instance be managed by orchestration"
  default     = false
}

variable "instance_type" {}

variable "subnet_id" {
  description = "The VPC subnet the instance(s) will go in"
}

variable "ami_id" {
  description = "The AMI to use"
}

variable "number_of_instances" {
  description = "number of instances to make"
  default     = 1
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "aws_region" {}

variable "vpc_security_group_ids" {
  default = []
}

variable "public_ip" {
  default = ""
}

variable "key_name" {
  default = ""
}

variable "availability_zone" {}

variable "block_device" {
  type = "map"

  default = {
    type                  = "none"
    delete_on_termination = true
  }
}
