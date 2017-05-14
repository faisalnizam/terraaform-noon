module "iam" {
  source = "../iam"

  name = "${var.name}"
  iam_policy  = "${var.iam_policy}"
}

resource "aws_launch_configuration" "lconf" {
  count = "${var.block_device["type"] == "none" ? 1 : 0}"

  name_prefix          = "${var.name}"
  image_id             = "${var.image_id}"
  key_name             = "${var.key_name}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${var.security_groups}"]
  enable_monitoring    = "${var.enable_monitoring}"
  user_data            = "${var.user_data}"
  iam_instance_profile = "${module.iam.profile_name}"

  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["ebs_block_device"]
  }
}

resource "aws_launch_configuration" "lconf_ebs" {
  count = "${var.block_device["type"] == "ebs" ? 1 : 0}"

  name_prefix          = "asg-lc-${var.name}"
  image_id             = "${var.image_id}"
  key_name             = "${var.key_name}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${var.security_groups}"]
  enable_monitoring    = "${var.enable_monitoring}"
  user_data            = "${var.user_data}"
  iam_instance_profile = "${module.iam.profile_name}"

  ebs_block_device {
    device_name           = "${lookup(var.block_device, "device_name", "/dev/xda")}"
    volume_type           = "${lookup(var.block_device, "volume_type", "gp2")}"
    volume_size           = "${lookup(var.block_device, "volume_size", 500)}"
    delete_on_termination = "${lookup(var.block_device, "delete_on_termination", true)}"
  }

  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["ebs_block_device"]
  }
}

resource "aws_launch_configuration" "lconf_ephemeral" {
  count = "${var.block_device["type"] == "ephemeral" ? 1 : 0}"

  name_prefix          = "asg-lc-${var.name}"
  image_id             = "${var.image_id}"
  key_name             = "${var.key_name}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${var.security_groups}"]
  enable_monitoring    = "${var.enable_monitoring}"
  user_data            = "${var.user_data}"
  iam_instance_profile = "${module.iam.profile_name}"

  ephemeral_block_device {
    device_name  = "${lookup(var.block_device, "device_name", "/dev/xda")}"
    virtual_name = "${lookup(var.block_device, "virtual_name", "ephemeral0")}"
  }

  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["ebs_block_device"]
  }
}
