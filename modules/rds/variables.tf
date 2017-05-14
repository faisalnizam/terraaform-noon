variable "allocated_storage" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "db_subnet" {}
variable "db_parametergroup" {}
variable "vpc_security_group_ids" { default = [] }
