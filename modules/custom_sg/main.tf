resource "aws_security_group" "custom_sg" {
  name = "${var.name}-custom_sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = "${var.from_port}"
    to_port = "${var.to_port}"
    protocol = "tcp"
    self = true
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

tags { 
    Name   = "${var.name}-custom_sg"
    propagate_at_launch = true
    } 
}
