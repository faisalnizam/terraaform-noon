variable "static_ip" {
  default = {
    master_aggregator = [
      "172.31.0.10",
      "172.31.0.11",
      "172.31.0.12",
      "172.31.0.13",
      "172.31.0.14",
    ]

    aggregator = [
      "172.31.0.15",
      "172.31.0.16",
      "172.31.0.17",
      "172.31.0.18",
      "172.31.0.19",
    ]

    leaf_node = [
      "172.31.0.20",
      "172.31.0.21",
      "172.31.0.22",
      "172.31.0.23",
      "172.31.0.24",
    ]
  }
}

variable "master_aggregator" {
  default = {
    ami           = "ami-7abd0209"
    instance_type = "r4.2xlarge"
    instance_name = "master aggregator"
    role          = "master-aggregator"
    count         = 1
  }
}

variable "aggregator" {
  default = {
    ami           = "ami-7abd0209"
    instance_type = "r4.2xlarge"
    instance_name = "aggregator"
    role          = "aggregator"
    count         = 1
  }
}

variable "leaf_node" {
  default = {
    ami           = "ami-7abd0209"
    instance_type = "r4.2xlarge"
    instance_name = "leaf node"
    role          = "leaf-node"
    count         = 1
  }
}

variable "region" {}
variable "environment" {}

variable "name" {
  default = "memsql-cluster"
}

variable "vpc_id" {
  default = "vpc-e1b7b685"
}

variable "aws_security_group_id" {
  default = {
    sg_id = ["sg-891f01ef"]
  }
}

variable "default_subnet" {
  default = "subnet-202f2544"
}

variable "key_name" {
  default = "dcos-eu-west1"
}

variable "zone_id" {
  default = "ZE6RLHQ5I7GDD"
}

variable "block_device" {
  default = "ephemeral"
}

variable "env" {
  default = "dev"
}

variable "vpc" {
  default = "vpc-e1b7b685"
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "orchestration" {
  default = false
}
