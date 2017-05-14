output "custom_sg_id" {
  value = ["${aws_security_group.custom_sg.*.id}"]
}
