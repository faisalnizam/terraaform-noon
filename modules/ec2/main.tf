provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_instance" "ec2_instance" {
  count = "${var.block_device["type"] == "none" ? var.number_of_instances : 0}"

  ami                         = "${var.ami_id}"
  subnet_id                   = "${var.subnet_id}"
  instance_type               = "${var.instance_type}"
  availability_zone           = "${var.availability_zone}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "${var.public_ip}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
  user_data                   = "${file(var.user_data)}"

  root_block_device {
    volume_size           = "${var.root_block_size}"
    delete_on_termination = "${var.root_delete_on_termination}"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.role, count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.role,
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

resource "aws_instance" "ec2_instance_ebs" {
  count = "${var.block_device["type"] == "ebs" ? var.number_of_instances : 0}"

  ami                         = "${var.ami_id}"
  subnet_id                   = "${var.subnet_id}"
  instance_type               = "${var.instance_type}"
  availability_zone           = "${var.availability_zone}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "${var.public_ip}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]

  //user_data                   = "${file(var.user_data)}"

  root_block_device {
    volume_size           = "${var.root_block_size}"
    delete_on_termination = "${var.root_delete_on_termination}"
  }
  ebs_block_device {
    device_name           = "${lookup(var.block_device, "device_name", "/dev/xda")}"
    volume_type           = "${lookup(var.block_device, "volume_type", "gp2")}"
    volume_size           = "${lookup(var.block_device, "volume_size", 25)}"
    delete_on_termination = "${lookup(var.block_device, "delete_on_termination", true)}"
  }
  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.role, count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.role,
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

resource "aws_instance" "ec2_instance_ephemeral" {
  count = "${var.block_device["type"] == "ephemeral" ? var.number_of_instances : 0}"

  ami                         = "${var.ami_id}"
  subnet_id                   = "${var.subnet_id}"
  instance_type               = "${var.instance_type}"
  availability_zone           = "${var.availability_zone}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "${var.public_ip}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
  user_data                   = "${file(var.user_data)}"

  root_block_device {
    volume_size           = "${var.root_block_size}"
    delete_on_termination = "${var.root_delete_on_termination}"
  }

  ephemeral_block_device {
    device_name  = "${lookup(var.block_device, "device_name", "/dev/xda")}"
    virtual_name = "${lookup(var.block_device, "virtual_name", "ephemeral0")}"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.role, count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.role,
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}
