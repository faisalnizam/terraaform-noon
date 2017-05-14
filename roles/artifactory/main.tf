provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
} // AWS Ends Here

module "sec_group" {
  source      = "../../modules/default_sg"
  name        = "default_asg_${var.name}"
  vpc_id      = "${var.vpc_id}"
  cidr_blocks = ["${var.cidr_blocks}"]
} // Security Group Ends Here

module "custom_sg" {
  name              = "${var.name}"
  source            = "../../modules/custom_sg"
  from_port         = "${var.from_port}"
  to_port           = "${var.to_port}"
  vpc_id            = "${var.vpc_id}"
  source_cidr_block = "0.0.0.0/0"
}

module "elb_sg" {
  source      = "../../modules/elb_sg"
  name        = "elb_sg_${var.name}"
  vpc_id      = "${var.vpc_id}"
  cidr_blocks = ["${var.cidr_blocks}"]

  // Define Tags
  cluster_name = "${var.cluster_name}"
} // Module Ends Here

module "elb" {
  source             = "../../modules/elb"
  name               = "${var.name}"
  security_groups    = ["${module.elb_sg.elb_sg_id}"]
  subnets            = ["${var.vpc_zone_identifier}"]
  ssl_certificate_id = "${var.ssl_certificate_id}"
  cluster_name       = "${var.cluster_name}"
  health_check_port  = "${var.health_check_port}"
}

module "asg" {
  source              = "../../modules/asg"
  name                = "artifcatory.management.prod"
  instance_type       = "${var.artifactory["instance_type"]}"
  image_id            = "${var.ami_id}"
  key_name            = "${var.artifactory["key_name"]}"
  min_size            = "${var.min_size}"
  max_size            = "${var.max_size}"
  desired_capacity    = "${var.total_instances}"
  force_delete        = "${var.delete}"
  enable_monitoring   = "${var.monitoring}"
  security_groups     = ["${module.sec_group.default_sg}", "${module.custom_sg.custom_sg_id}"]
  vpc_zone_identifier = ["${var.vpc_zone_identifier_ec2}"]
  load_balancers      = ["${module.elb.elb_name}"]
  availability_zones  = ["${var.availability_zones}"]
  user_data           = "${data.template_file.launch_artifactory.rendered}"

  role = "Artifactory"
  env  = "${var.profile}"
  vpc  = "${var.vpc}"
  name = "artifcatory.${var.vpc}.${var.profile}"
} // Auto Scaling Group Ends Here

resource "aws_ebs_volume" "extrenal_volume" {
  availability_zone = "eu-central-1a"
  size              = 1024
  iops              = 10000
  type              = "io1"

  tags {
    Name         = "Artifactory"
    Role         = "artifactory"
    Orchestation = "Off"
  }
} //Creation of Volume Finishes Here 

data "template_file" "launch_artifactory" {
  vars {
    archive_link  = "${var.archive_link}"
    playbook_name = "artifactory"
    env           = "${var.profile}"
    ebs_volume_id = "${aws_ebs_volume.extrenal_volume.id}"
    index_value   = "${count.index}"
  }

  template = "${file("${path.module}/templates/artifactory.tpl")}"
} // User Data or Template and Ansible Book Definition

resource "aws_route53_record" "artifactory" {
  zone_id = "${var.zone_id}"
  name    = "${var.dns_address}"
  type    = "${var.record_type}"

  alias {
    name                   = "${module.elb.elb_dns_name}"
    zone_id                = "${module.elb.elb_zone_id}"
    evaluate_target_health = true
  }
}
