provider "aws" {
  region  = "${var.region}"
  profile = "${var.environment}"
}

resource "aws_security_group" "default-sec-group" {
  name        = "${var.name}"
  description = "Analytics cluster sec. group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name    = "${var.name}"
    cluster = "${var.name}"
    product = "${var.name}"
    purpose = "${var.name}"
    builder = "terraform"
  }

  // office access
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    cidr_blocks = [
      "10.105.0.0/16",     // production cluster
      "10.104.0.0/16",     // dev cluster
      "10.107.0.0/16",
      "10.98.0.0/16",
      "91.74.235.114/32",  // Dubai office
      "151.253.56.114/32", // CFC
      "91.74.235.26/32",   // Bartek's IP
      "93.35.249.37/32",   // Stefano's IP
      "51.140.42.166/32",  // VPN Access
    ]
  }

  ingress {
    from_port = "32001"
    to_port   = "32002"
    protocol  = "TCP"

    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = "50070"
    to_port     = "50070"
    protocol    = "tcp"
    cidr_blocks = ["10.199.0.0/16"]
  }

  ingress {
    from_port   = "8088"
    to_port     = "8088"
    protocol    = "tcp"
    cidr_blocks = ["10.199.0.0/16"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Temporary SMP Datawarehouse
resource "aws_instance" "ec2-smp-datawarehouse" {
  count = "${var.smp_datawarehouse["count"]}"

  ami                         = "${var.smp_datawarehouse["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.smp_datawarehouse["instance_type"]}"
  availability_zone           = "eu-central-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["smp_datawarehouse"], count.index)}"
  iam_instance_profile        = "analytics-backup"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = "true"
  }

  # Data
  ephemeral_block_device {
    device_name  = "/dev/sdb"
    virtual_name = "ephemeral0"
  }

  # Data
  ephemeral_block_device {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral1"
  }

  # Logs - always under /dev/sdz
  ebs_block_device {
    device_name           = "/dev/sdz"
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.smp_datawarehouse["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.smp_datawarehouse["role"],
    "Index", count.index,
    "mysql", "mysql", 
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

// Data warehouse management nodes
resource "aws_instance" "ec2-dw-manager" {
  count = "${var.dw_manager["count"]}"

  ami                         = "${var.dw_manager["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.dw_manager["instance_type"]}"
  availability_zone           = "eu-central-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["dw_manager"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "70"
    delete_on_termination = "true"
  }

  # Data
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
  }

  # Logs - always under /dev/sdz
  ebs_block_device {
    device_name           = "/dev/sdz"
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.dw_manager["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.dw_manager["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

// Data warehouse worker nodes
resource "aws_instance" "ec2-dw-worker" {
  count = "${var.dw_worker["count"]}"

  ami                         = "${var.dw_worker["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.dw_worker["instance_type"]}"
  availability_zone           = "eu-central-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["dw_worker"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = "true"
  }

  # Data
  ephemeral_block_device {
    device_name  = "/dev/sdb"
    virtual_name = "ephemeral0"
  }

  # Data
  ephemeral_block_device {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral1"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.dw_worker["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.dw_worker["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

// Workflow scheduler - manager & worker
resource "aws_instance" "ec2-worflow-scheduler-manager" {
  count = "${var.scheduler_master["count"]}"

  ami                         = "${var.scheduler_master["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.scheduler_master["instance_type"]}"
  availability_zone           = "eu-central-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["scheduler_master"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "80"
    delete_on_termination = "true"
  }

  # Data
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.scheduler_master["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.scheduler_master["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

// Workflow scheduler worker nodes
resource "aws_instance" "ec2-worflow-scheduler-worker" {
  count = "${var.scheduler_worker["count"]}"

  ami                         = "${var.scheduler_worker["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.scheduler_worker["instance_type"]}"
  availability_zone           = "eu-central-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["scheduler_worker"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "25"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.scheduler_worker["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.scheduler_worker["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

// Hadoop cluster manager instances, NameNode, Resource Manager etc.
resource "aws_instance" "ec2-cluster-manager" {
  count = "${var.cluster_manager["count"]}"

  ami                         = "${var.cluster_manager["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.cluster_manager["instance_type"]}"
  availability_zone           = "eu-central-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["cluster_manager"], count.index)}"
  iam_instance_profile        = "analytics-backup"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "70"
    delete_on_termination = "true"
  }

  # Primary Hadoop DFS
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "gp2"
    volume_size           = "150"
    delete_on_termination = "true"
  }

  # Secondary Hadoop DFS
  ebs_block_device {
    device_name           = "/dev/sdc"
    volume_type           = "gp2"
    volume_size           = "150"
    delete_on_termination = "true"
  }

  # Logs - always under /dev/sdz
  ebs_block_device {
    device_name           = "/dev/sdz"
    volume_type           = "gp2"
    volume_size           = "150"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.cluster_manager["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.cluster_manager["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

// Hadoop cluster edge nodes - user facing services like Cloudera Manager, HiveServer2 etc.
resource "aws_instance" "ec2-cluster-edge" {
  count = "${var.cluster_edge["count"]}"

  ami                         = "${var.cluster_edge["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.cluster_edge["instance_type"]}"
  availability_zone           = "eu-central-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["cluster_edge"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
  }

  # Logs - always under /dev/sdz
  ebs_block_device {
    device_name           = "/dev/sdz"
    volume_type           = "gp2"
    volume_size           = "150"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.cluster_edge["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.cluster_edge["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

// Hadoop DataNodes
resource "aws_instance" "ec2-cluster-worker" {
  count = "${var.cluster_worker["count"]}"

  ami                         = "${var.cluster_worker["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.cluster_worker["instance_type"]}"
  availability_zone           = "eu-central-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["cluster_worker"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "70"
    delete_on_termination = "true"
  }

  # Big Data goes here
  ephemeral_block_device {
    device_name  = "/dev/sdb"
    virtual_name = "ephemeral0"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral1"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdd"
    virtual_name = "ephemeral2"
  }

  ephemeral_block_device {
    device_name  = "/dev/sde"
    virtual_name = "ephemeral3"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdf"
    virtual_name = "ephemeral4"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdg"
    virtual_name = "ephemeral5"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdh"
    virtual_name = "ephemeral6"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdi"
    virtual_name = "ephemeral7"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdj"
    virtual_name = "ephemeral8"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdk"
    virtual_name = "ephemeral9"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdl"
    virtual_name = "ephemeral10"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdm"
    virtual_name = "ephemeral11"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdn"
    virtual_name = "ephemeral12"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdo"
    virtual_name = "ephemeral13"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdp"
    virtual_name = "ephemeral14"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdq"
    virtual_name = "ephemeral15"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdr"
    virtual_name = "ephemeral16"
  }

  ephemeral_block_device {
    device_name  = "/dev/sds"
    virtual_name = "ephemeral17"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdt"
    virtual_name = "ephemeral18"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdu"
    virtual_name = "ephemeral19"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdv"
    virtual_name = "ephemeral20"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdw"
    virtual_name = "ephemeral21"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdx"
    virtual_name = "ephemeral22"
  }

  ephemeral_block_device {
    device_name  = "/dev/sdy"
    virtual_name = "ephemeral23"
  }

  # Logs - always under /dev/sdz
  ebs_block_device {
    device_name           = "/dev/sdz"
    volume_type           = "gp2"
    volume_size           = "150"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.cluster_worker["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.cluster_worker["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

// Cluster stream broker
resource "aws_instance" "ec2-cluster-streambroker" {
  count = "${var.cluster_streambroker["count"]}"

  ami                         = "${var.cluster_streambroker["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.cluster_streambroker["instance_type"]}"
  availability_zone           = "eu-central-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["cluster_streambroker"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = "true"
  }

  # Data
  ephemeral_block_device {
    device_name  = "/dev/sdb"
    virtual_name = "ephemeral0"
  }

  # Logs - always under /dev/sdz
  ebs_block_device {
    device_name           = "/dev/sdz"
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.cluster_streambroker["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.cluster_streambroker["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

// Data Science dedicated VMs
resource "aws_instance" "ec2-data-science-node" {
  count = "${var.data_science["count"]}"

  ami                         = "${var.data_science["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.data_science["instance_type"]}"
  availability_zone           = "eu-central-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["data_science"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "80"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.data_science["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.data_science["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

// Dashboarding and reporting VMs
resource "aws_instance" "ec2-reporting-node" {
  count = "${var.reporting_node["count"]}"

  ami                         = "${var.reporting_node["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.reporting_node["instance_type"]}"
  availability_zone           = "eu-central-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["reporting_node"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "25"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.reporting_node["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.reporting_node["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}
