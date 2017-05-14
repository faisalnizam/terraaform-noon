data "aws_availability_zones" "available" {}
variable "region" {}
variable "environment" {}

variable "source_cidr" {
  type = "list"
}

variable "cidr" {}
