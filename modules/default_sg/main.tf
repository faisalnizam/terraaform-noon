resource "aws_security_group" "default_sg" {
    name = "${var.name}"
    vpc_id = "${var.vpc_id}"

 ingress {
        from_port = 32001
        to_port = 32002
        protocol = "tcp"
        //self = true
        cidr_blocks = ["0.0.0.0/0"]
	}

 ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        //self = true              
        cidr_blocks = ["0.0.0.0/0"]
        }

 ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        //self = true              
        }

  ingress {
          from_port = 80
          to_port = 80
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
       }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }  

    tags { 
        Name = "${var.name}-default_sg" 
        propagate_at_launch = true
}


}
