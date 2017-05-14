module "lconf" {
  source            = "../launch_configuration"
  name              = "${var.name}"
  image_id          = "${var.image_id}"
  key_name          = "${var.key_name}"
  instance_type     = "${var.instance_type}"
  security_groups   = ["${var.security_groups}"]
  enable_monitoring = "${var.enable_monitoring}"
  user_data         = "${var.user_data}"
  block_device      = "${var.block_device}"
  iam_policy        = "${var.iam_policy}"
}

resource "aws_autoscaling_group" "asg" {
  name                      = "asg-${var.role}"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  health_check_grace_period = 5000
  health_check_type         = "${var.health_check_type}"
  desired_capacity          = "${var.desired_capacity}"
  force_delete              = "${var.force_delete}"
  availability_zones        = ["${var.availability_zones}"]
  vpc_zone_identifier       = ["${var.vpc_zone_identifier}"]
  load_balancers            = ["${var.load_balancers}"]
  launch_configuration      = "${module.lconf.name}"

  tag {
    propagate_at_launch = true
    key                 = "created_by"
    value               = "terraform"
  }

  tag {
    propagate_at_launch = true
    key                 = "Orchestration"
    value               = "${var.orchestration}"
  }

  tag {
    propagate_at_launch = true
    key                 = "Role"
    value               = "${var.role}"
  }

  tag {
    propagate_at_launch = true
    key                 = "Env"
    value               = "${var.env}"
  }

  tag {
    propagate_at_launch = true
    key                 = "VPC"
    value               = "${var.vpc}"
  }

 tag { 
    propagate_at_launch = true  
    key                 = "Name" 
    value               = "${var.name}" 

    }
}
