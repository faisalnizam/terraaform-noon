/**
* ASAV's security groups
*/
resource "aws_security_group" "asav" {
  name = "${var.cluster_name}.${var.vpc}.${var.profile}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["151.253.56.114/32"]
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["52.59.138.199/32"]
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["52.59.236.165/32"]
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["52.59.94.212/32"]
  }

  ingress {
    from_port   = "500"
    to_port     = "500"
    protocol    = "UDP"
    cidr_blocks = ["51.140.42.166/32"]
  }

  ingress {
    from_port   = "4500"
    to_port     = "4500"
    protocol    = "UDP"
    cidr_blocks = ["51.140.42.166/32"]
  }

  ingress {
    from_port   = "500"
    to_port     = "500"
    protocol    = "UDP"
    cidr_blocks = ["91.74.235.114/32"]
  }

  ingress {
    from_port   = "4500"
    to_port     = "4500"
    protocol    = "UDP"
    cidr_blocks = ["91.74.235.114/32"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["185.122.37.20/32"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["51.140.42.166/32"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["91.74.235.114/32"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["94.204.56.89/32"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["94.207.140.150/32"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["122.183.234.146/32"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["151.253.56.114/32"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["185.122.37.20/32"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["203.199.223.149/32"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["94.204.56.89/32"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["94.207.140.150/32"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["122.183.234.146/32"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["151.253.56.114/32"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["176.227.193.92/32"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["185.122.37.20/32"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["203.199.223.149/32"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["51.140.42.166/32"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["91.74.235.114/32"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["94.204.56.89/32"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["94.207.140.150/32"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "${var.cluster_name}_asav_monlog"
    Description = "Allow services from the private subnet through ASAv"
    cluster     = "${var.cluster_name}"
    product     = "${var.tag_product}"
    purpose     = "${var.tag_purpose}"
    builder     = "terraform_extreme"
  }
}

resource "aws_instance" "asava" {
  monitoring        = true
  availability_zone = "eu-central-1a"
  ami               = "${var.ami}"
  instance_type     = "${var.instance_type}"
  key_name          = "${var.key_name}"

  vpc_security_group_ids = ["${aws_security_group.asav.id}"]
  subnet_id              = "subnet-cf8c42a7"

  associate_public_ip_address = true
  source_dest_check           = false

  tags {
    Name        = "${var.cluster_name}.${var.vpc}.${var.profile}"
    Description = "Allow services through ASAv"
    cluster     = "${var.cluster_name}"
    product     = "${var.tag_product}"
    purpose     = "${var.tag_purpose}"
    builder     = "terraform_extreme"
  }
}

resource "aws_instance" "asavb" {
  monitoring        = true
  availability_zone = "eu-central-1b"
  ami               = "${var.ami}"
  instance_type     = "${var.instance_type}"
  key_name          = "${var.key_name}"

  vpc_security_group_ids = ["${aws_security_group.asav.id}"]
  subnet_id              = "subnet-ed352a96"

  associate_public_ip_address = true
  source_dest_check           = false

  tags {
    Name        = "${var.cluster_name}.${var.vpc}.${var.profile}"
    Description = "Allow services through ASAv"
    cluster     = "${var.cluster_name}"
    product     = "${var.tag_product}"
    purpose     = "${var.tag_purpose}"
    builder     = "terraform_extreme"
  }
}

resource "aws_eip" "asava" {
  vpc               = true
  count             = 2
  network_interface = "${element(aws_network_interface.asava-public.*.id, count.index)}"
}

resource "aws_eip" "asavb" {
  vpc               = true
  count             = 2
  network_interface = "${element(aws_network_interface.asavb-public.*.id, count.index)}"
}

resource "aws_network_interface" "asava-public" {
  count             = 2
  subnet_id         = "${element(split(",",var.subneta_ids), count.index)}"
  security_groups   = ["${aws_security_group.asav.id}"]
  source_dest_check = false

  attachment {
    instance     = "${aws_instance.asava.id}"
    device_index = "${count.index + 1}"
  }

  tags {
    Name    = "${var.cluster_name}"
    cluster = "${var.cluster_name}"
    product = "${var.tag_product}"
    purpose = "${var.tag_purpose}"
    builder = "terraform_extreme"
  }
}

resource "aws_network_interface" "asavb-public" {
  count             = 2
  subnet_id         = "${element(split(",",var.subnetb_ids), count.index)}"
  security_groups   = ["${aws_security_group.asav.id}"]
  source_dest_check = false

  attachment {
    instance     = "${aws_instance.asavb.id}"
    device_index = "${count.index + 1}"
  }

  tags {
    Name    = "${var.cluster_name}"
    cluster = "${var.cluster_name}"
    product = "${var.tag_product}"
    purpose = "${var.tag_purpose}"
    builder = "terraform_extreme"
  }
}
