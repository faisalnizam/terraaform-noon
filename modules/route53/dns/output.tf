output "fqdn_domain_name" {
  value = "${aws_route53_record.create_dns.fqdn}"
}
