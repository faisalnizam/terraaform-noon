# Global variables
variable "cluster_name" {
  default     = ""
  description = "Name of the cluster (must be uniq per region)"
}

variable "vpc" {
  default     = ""
  description = "Name of the VPC"
}

variable "region" {
  default     = ""
  description = "AWS region to setup the cluster"
}

variable "profile" {
  default     = "dev"
  description = ""
}

variable "tag_product" {
  default     = "bastion"
  description = "when setup a product tag is setup on all resources, with that value"
}

variable "tag_purpose" {
  default     = "poc"
  description = "when setup a purpose tag is setup on all resources, with that value"
}

variable "bastion_extra_user_data" {
  default     = ""
  description = "extra user data that you can add to the launch configuration"
}

variable "key_name" {
  default     = ""
  description = "key name use for bastion"
}

variable "ami" {
  default     = ""
  description = "ami use for bastion"
}

variable "instance_type" {
  default     = "m4.xlarge"
  description = "instance type used for bastion"
}

variable "vpc_id" {
  default     = ""
  description = "VPC ID"
}

variable "subneta_ids" {
  description = "List of subnets inside the VPC"
  default     = ""
}

variable "subnetb_ids" {
  description = "List of subnets inside the VPC"
  default     = ""
}
