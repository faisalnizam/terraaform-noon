# Route53 DNS Terraform Module

A Terraform Route53 DNS module

## Input Variables

 - `dns_name` - (Required) The name of the record
 - `route_zone_id` - (Required) The ID of the hosted zone to contain this record
 - `type` - (Required) The record type
 - `records` - (Required for non-alias records) A string list of records
 - `ttl` - (Required for non-alias records) The TTL of the record

 ## Usage

 You can use these in your terraform template with the following steps:

 ```
 module "route53" {
   source  = "../../modules/route53/dns"
   name    = "${var.name}"
   zone_id = "${var.route_zone_id}"
   type    = "${var.dns_type}"
   ttl     = "${var.ttl}"
   records = ["${var.records}"]
 }
 ```
