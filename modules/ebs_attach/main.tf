resource "aws_volume_attachment" "ebs_att" {
  device_name  = "${var.device_name}"
  volume_id    = "${var.volume_id}"
  instance_id  = "${var.instance_id}"
  skip_destroy = true
}
