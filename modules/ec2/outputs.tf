// Output the ID of the EC2 instance created
output "ec2_instance_id" {
  value = ["${aws_instance.ec2_instance.*.id}"]
}

output "ec2_instance_ebs_id" {
  value = ["${aws_instance.ec2_instance_ebs.*.id}"]
}

output "ec2_instance_ephemeral_id" {
  value = ["${aws_instance.ec2_instance_ephemeral.*.id}"]
}

output "ec2_instance_ip" {
  value = "${join(",", aws_instance.ec2_instance.*.private_ip)}"
}
