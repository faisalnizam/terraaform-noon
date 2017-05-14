variable "name" {
  type        = "string"
  description = "The name of the record"
  default     = ""
}

variable "zone_id" {
  type        = "string"
  description = "The ID of the hosted zone to contain this record"
  default     = ""
}

variable "records" {
  description = "A string list of records"
  default     = [""]
}

variable "type" {
  type        = "string"
  description = "The record type"
  default     = "CNAME"
}

variable "ttl" {
  type        = "string"
  description = "The TTL of the record"
  default     = "300"
}
