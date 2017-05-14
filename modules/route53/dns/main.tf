resource "aws_route53_record" "create_dns" {
  name    = "${var.name}"
  zone_id = "${var.zone_id}"
  type    = "${var.type}"
  ttl     = "${var.ttl}"
  records = ["${var.records}"]
}
