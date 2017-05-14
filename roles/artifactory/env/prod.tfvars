count = 1

region = "eu-central-1"
environment = "prod"
env         = "prod"
key_name = "prod"
name = "Artifcatory"
application = "Artifactory"
hostname = "artifactory-1"
domain = "noon.com"

ami_id = "ami-9bf712f4" // base centos 7
instance_type = "m4.4xlarge"
vpc = "management"
vpc_id = "vpc-5d726534" // dit-management-vpc

min_size = 1
max_size = 3
total_instances = 1
monitoring = "false"
delete = "false"

availability_zones = ["eu-central-1a"]
vpc_zone_identifier = ["subnet-cf8c42a7"]
vpc_zone_identifier_ec2 = ["subnet-c08c42a8"]
subnets = ["10.99.3.0/24", "10.99.4.0/24"]

zone_id = "Z3I91H6QNBJ8DO"
dns_address = "artifactory.prod.fastfish.io" 
record_type = "A" 
records = [""]

cidr_blocks = ["0.0.0.0/0"]
load_balancers = ["abc-def12345"]
health_check_port = 8081 
health_check_type = "ELB"
from_port   = 8080 
to_port     = 8081

file_name = "artifactory.tpl"
ssl_certificate_id = "arn:aws:acm:eu-central-1:433703733157:certificate/182a45ce-c132-4336-965d-66ac977d76cf"
archive_link = "https://git.fastfish.io/devops/config-management/repository/archive.zip?ref=master&private_token=WZXfUD9mUo8ayYLuYXCt"


// Define Tags Here
cluster_name = "Artifactory"
tag_product = "Artifactory-Environment"
tag_purpose = "Development and CI"
artifactory = {
  extra_user_data = ""
  key_name        = "prod"
  ami             = "ami-9bf712f4"
  instance_type   = "m4.4xlarge"
}


//availability_zones = ["eu-central-1a", "eu-central-1b"]
//vpc_zone_identifier = ["subnet-cf8c42a7", "subnet-ed352a96"]
//vpc_zone_identifier_ec2 = ["subnet-c08c42a8", "subnet-e2352a99"]


