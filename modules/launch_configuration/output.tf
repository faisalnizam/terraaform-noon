output "id" {
  value = "${
    var.block_device["type"] == "none" ? aws_launch_configuration.lconf.id :
      var.block_device["type"] == "ebs" ? aws_launch_configuration.lconf_ebs.id : aws_launch_configuration.lconf_ephemeral.id }"
}

output "name" {
  value = "${aws_launch_configuration.lconf.name}"
}
