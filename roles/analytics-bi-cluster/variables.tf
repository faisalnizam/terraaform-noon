variable "static_ip" {
  default = {
    dw_manager = [
      "10.105.3.10",
      "10.105.3.11",
      "10.105.3.12",
      "10.105.3.13",
      "10.105.3.14",
    ]

    dw_worker = [
      "10.105.3.15",
      "10.105.3.16",
      "10.105.3.17",
      "10.105.3.18",
      "10.105.3.19",
    ]

    scheduler_master = [
      "10.105.3.20",
      "10.105.3.21",
      "10.105.3.22",
      "10.105.3.23",
      "10.105.3.24",
    ]

    scheduler_worker = [
      "10.105.3.25",
      "10.105.3.26",
      "10.105.3.27",
      "10.105.3.28",
      "10.105.3.29",
      "10.105.3.30",
      "10.105.3.31",
      "10.105.3.32",
      "10.105.3.33",
      "10.105.3.34",
    ]

    cluster_manager = [
      "10.105.3.35",
      "10.105.3.36",
      "10.105.3.37",
      "10.105.3.38",
      "10.105.3.39",
    ]

    cluster_edge = [
      "10.105.3.40",
      "10.105.3.41",
      "10.105.3.42",
      "10.105.3.43",
      "10.105.3.40",
    ]

    data_science = [
      "10.105.3.45",
    ]

    reporting_node = [
      "10.105.3.46",
    ]

    //temporary
    smp_datawarehouse = [
      "10.105.3.47",
    ]

    // kafka instances
    cluster_streambroker = [
      "10.105.3.48",
      "10.105.3.49",
      "10.105.3.50",
    ]

    # reserved addresses from 51 - 100 go here

    cluster_worker = [
      "10.105.3.100",
      "10.105.3.101",
      "10.105.3.102",
      "10.105.3.103",
      "10.105.3.104",
      "10.105.3.105",
      "10.105.3.106",
      "10.105.3.107",
      "10.105.3.108",
      "10.105.3.109",
      "10.105.3.110",
      "10.105.3.111",
      "10.105.3.112",
      "10.105.3.113",
      "10.105.3.114",
      "10.105.3.115",
      "10.105.3.116",
      "10.105.3.117",
      "10.105.3.118",
      "10.105.3.119",
      "10.105.3.120",
      "10.105.3.121",
      "10.105.3.122",
      "10.105.3.123",
      "10.105.3.124",
      "10.105.3.125",
      "10.105.3.126",
      "10.105.3.127",
      "10.105.3.128",
      "10.105.3.129",
      "10.105.3.130",
    ]
  }
}

variable "smp_datawarehouse" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "i3.4xlarge"
    instance_name = "SMP datawarehouse"
    role          = "smp-datawarehouse"
    count         = 1
  }
}

variable "dw_manager" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "r4.2xlarge"
    instance_name = "datawarehouse manager"
    role          = "datawarehouse-manager"
    count         = 0
  }
}

variable "dw_aggregator" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "r4.2xlarge"
    instance_name = "datawarehouse aggregator"
    role          = "datawarehouse-aggregator"
    count         = 0
  }
}

variable "dw_worker" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "i3.4xlarge"
    instance_name = "datawarehouse worker"
    role          = "datawarehouse-worker"
    count         = 0
  }
}

variable "scheduler_master" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "m4.xlarge"
    instance_name = "workflow scheduler manager"
    role          = "workflow-scheduler-manager"
    count         = 1
  }
}

variable "scheduler_worker" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "m4.xlarge"
    instance_name = "workflow scheduler worker"
    role          = "workflow-scheduler-worker"
    count         = 0
  }
}

variable "cluster_manager" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "r4.2xlarge"
    instance_name = "cluster manager"
    role          = "cluster-manager"
    count         = 3
  }
}

variable "cluster_edge" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "m4.4xlarge"
    instance_name = "cluster edge"
    role          = "cluster-edge"
    count         = 2
  }
}

variable "cluster_worker" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "d2.8xlarge"
    instance_name = "cluster worker"
    role          = "cluster-worker"
    count         = 3
  }
}

variable "cluster_streambroker" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "c3.4xlarge"
    instance_name = "cluster stream broker"
    role          = "cluster-stream-broker"
    count         = 3
  }
}

variable "data_science" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "r4.2xlarge"
    instance_name = "data science node"
    role          = "data-science-node"
    count         = 0
  }
}

variable "reporting_node" {
  default = {
    ami           = "ami-9bf712f4"
    instance_type = "m4.xlarge"
    instance_name = "reporting node"
    role          = "reporting-node"
    count         = 1
  }
}

variable "region" {}

variable "environment" {}

variable "name" {
  default = "analytics-bi-cluster"
}

variable "vpc_id" {
  default = "vpc-1e3d8876"
}

variable "aws_security_group_id" {
  default = {
    sg_id = ["sg-9d7987f6"]
  }
}

variable "default_subnet" {
  default = "subnet-72c5b01a"
}

variable "key_name" {
  default = "prod"
}

variable "zone_id" {
  default = "Z3AYZWEIGZ5BX2"
}

variable "block_device" {
  default = "ephemeral"
}

variable "env" {
  default = "prod"
}

variable "vpc" {
  default = "analytics"
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "orchestration" {
  default = "true"
}
