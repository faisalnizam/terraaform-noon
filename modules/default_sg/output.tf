output "default_sg" {
    value = ["${aws_security_group.default_sg.id}"]
}

