provider "aws" {
  region     = "${var.region}"
  profile    = "${var.environment}"
  access_key = "YOURAWSKEYID"
  secret_key = "YOURAWSSECRET"
}

//optional security group
resource "aws_security_group" "default-sec-group" {
  name        = "${var.name}"
  description = "cluster sec. group"
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
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["91.74.235.114/32", "91.74.235.26/32", "5.31.62.130/32"]
  }

  ingress {
    from_port   = "9000"
    to_port     = "9000"
    protocol    = "-1"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//memSQL master aggregator 
resource "aws_instance" "memsql-master-aggregator" {
  count                       = "${var.master_aggregator["count"]}"
  ami                         = "${var.master_aggregator["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.master_aggregator["instance_type"]}"
  availability_zone           = "eu-west-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["master_aggregator"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.master_aggregator["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.master_aggregator["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

resource "aws_route53_record" "r53-master-aggregator" {
  count   = "${var.master_aggregator["count"]}"
  zone_id = "${var.zone_id}"
  name    = "${format("memsqlmaster%02d", count.index + 1)}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.memsql-master-aggregator.*.private_ip, count.index)}"]
}

//memSQL aggregator
resource "aws_instance" "memsql-aggregator" {
  count                       = "${var.aggregator["count"]}"
  ami                         = "${var.aggregator["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.aggregator["instance_type"]}"
  availability_zone           = "eu-west-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["aggregator"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.aggregator["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.aggregator["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

resource "aws_route53_record" "r53-aggregator" {
  count   = "${var.aggregator["count"]}"
  zone_id = "${var.zone_id}"
  name    = "${format("aggregator%02d", count.index + 1)}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.memsql-aggregator.*.private_ip, count.index)}"]
}

//memSQL leaf node 
resource "aws_instance" "memsql-leaf-node" {
  count                       = "${var.leaf_node["count"]}"
  ami                         = "${var.leaf_node["ami"]}"
  subnet_id                   = "${var.default_subnet}"
  instance_type               = "${var.leaf_node["instance_type"]}"
  availability_zone           = "eu-west-1a"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.default-sec-group.id}"]
  private_ip                  = "${element(var.static_ip["leaf_node"], count.index)}"

  # OS
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
  }

  tags = "${merge(map(
    "Name", format("%s-%d.%s.%s", var.leaf_node["role"], count.index, var.vpc, var.env),
    "created_by", "terraform",
    "Orchestration", var.orchestration,
    "Role", var.leaf_node["role"],
    "Index", count.index,
    "Env", var.env,
    "VPC", var.vpc), var.tags)}"
}

resource "aws_route53_record" "r53-leaf-node" {
  count   = "${var.leaf_node["count"]}"
  zone_id = "${var.zone_id}"
  name    = "${format("leaf%02d", count.index + 1)}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.memsql-leaf-node.*.private_ip, count.index)}"]
}

output "memsql_master_aggregator_public_ips" {
  value = "${join("\n", aws_instance.memsql-master-aggregator.*.public_ip)}"
}

output "memsql_aggregator_public_ips" {
  value = "${join("\n  - ", aws_instance.memsql-aggregator.*.public_ip)}"
}

output "memsql_leaf_node_public_ips" {
  value = "${join("\n", aws_instance.memsql-leaf-node.*.public_ip)}"
}

resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires adjusting the ansible configuration
  triggers {
    mcount = "${var.master_aggregator["count"]}"
    acount = "${var.aggregator["count"]}"
    lcount = "${var.leaf_node["count"]}"
  }

  provisioner "local-exec" {
    command = "bash make_hostsfile.sh"
  }
}
