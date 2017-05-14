region = "eu-west-1"
environment = "dev"
default_subnet = "subnet-1fb0b869"
vpc_id = "vpc-e1b7b685"
zone_id = "ZE6RLHQ5I7GDD"
env = "dev"

master_aggregator = {
  count = 1
}

aggregator = {
  count = 1
}

leaf_node = {
  count = 1
}

aws_security_group_id = {
  sg_id = ["sg-c57b85ae"]
}

static_ip = {
  master_aggregator = [
    "172.31.0.1",
    "172.31.0.2",
    "172.31.0.3",
    "172.31.0.4",
    "172.31.0.5"
  ],
  aggregator = [
    "172.31.0.15",
    "172.31.0.16",
    "172.31.0.17",
    "172.31.0.18",
    "172.31.0.19"
  ],
  leaf_node = [
    "172.31.0.35",
    "172.31.0.36",
    "172.31.0.37",
    "172.31.0.38",
    "172.31.0.39"
  ]
}
