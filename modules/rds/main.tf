resource "aws_db_instance" "default" {
  allocated_storage    = "${var.allocated_storage}"
  engine               = "${var.engine}"
  engine_version       = "${var.engine_version}"
  instance_class       = "${var.instance_class}"
  name                 = "${var.db_name}"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  db_subnet_group_name = "${var.db_subnet}"
  parameter_group_name = "${var.db_parametergroup}"
  vpc_security_group_ids = "${var.vpc_security_group_ids}"
}

