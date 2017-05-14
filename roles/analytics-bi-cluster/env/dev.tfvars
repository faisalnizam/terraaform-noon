
dw_manager = {
  count = 1
}

dw_worker = {
  count = 1
}

cluster_manager = {
  count = 1
}

cluster_edge = {
  count = 1
}

cluster_worker = {
  count = 2
}

cluster_streambroker = {
  count = 2
}

orchestration = "false"
region = "eu-central-1"
environment = "dev"
default_subnet = "subnet-82dbaeea"
aws_security_group_id = {
  sg_id = ["sg-c57b85ae"]
}

vpc_id = "vpc-0e328766"

zone_id = "ZE6RLHQ5I7GDD"

env = "dev"

static_ip = {
  dw_manager = [
    "10.104.3.10",
    "10.104.3.11",
    "10.104.3.12",
    "10.104.3.13",
    "10.104.3.14"
  ],

  dw_worker = [
    "10.104.3.15",
    "10.104.3.16",
    "10.104.3.17",
    "10.104.3.18",
    "10.104.3.19"
  ],

  scheduler_master = [
    "10.104.3.20",
    "10.104.3.21",
    "10.104.3.22",
    "10.104.3.23",
    "10.104.3.24"
  ],

  scheduler_worker = [
    "10.104.3.25",
    "10.104.3.26",
    "10.104.3.27",
    "10.104.3.28",
    "10.104.3.29",
    "10.104.3.30",
    "10.104.3.31",
    "10.104.3.32",
    "10.104.3.33",
    "10.104.3.34"
  ],

  cluster_manager = [
    "10.104.3.35",
    "10.104.3.36",
    "10.104.3.37",
    "10.104.3.38",
    "10.104.3.39"
  ],

  cluster_edge = [
    "10.104.3.40",
    "10.104.3.41",
    "10.104.3.42",
    "10.104.3.43",
    "10.104.3.44",
  ]

  data_science = [
    "10.104.3.45",
  ]

  reporting_node = [
    "10.104.3.46",
  ]

  //temporary SMP data warehouse
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
    "10.104.3.100",
    "10.104.3.101",
    "10.104.3.102",
    "10.104.3.103",
    "10.104.3.104",
    "10.104.3.105",
    "10.104.3.106",
    "10.104.3.107",
    "10.104.3.108",
    "10.104.3.109",
    "10.104.3.110"
  ]
}
