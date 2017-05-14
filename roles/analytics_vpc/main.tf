provider "aws" {
  region  = "${var.region}"
  profile = "${var.environment}"
}

module "data_vpc" {
  source = "../../modules/vpc"
  name   = "analytics_vpc"
  cidr   = "${var.cidr}"

  private_subnets = [
    "${cidrsubnet(var.cidr, 8, 1)}",
    "${cidrsubnet(var.cidr, 8, 2)}",
  ]

  public_subnets = [
    "${cidrsubnet(var.cidr, 8, 3)}",
    "${cidrsubnet(var.cidr, 8, 4)}",
  ]

  enable_nat_gateway   = "true"
  azs                  = ["${data.aws_availability_zones.available.names}"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "generic_sg" {
  source      = "../../modules/default_sg"
  name        = "analytics_base_sg"
  vpc_id      = "${module.data_vpc.vpc_id}"
  cidr_blocks = ["${var.source_cidr}"]
}
