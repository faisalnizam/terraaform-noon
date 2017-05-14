count = 1

region = "eu-west-1"

profile = "dev"

key_name = "test"

name = "artifactory"

application = "Artifactory"

#ami_id = "ami-00787074" // base centos 7
ami_id = "ami-7abd0209" 

instance_type = "m4.4xlarge"

vpc = "management"

vpc_id = "vpc-146a1270"


//vpc_zone_identifier = ["subnet-e2e5b486","subnet-1e195168"]
//availability_zones = ["eu-west-1a", "eu-west-1b"]

vpc_zone_identifier = ["subnet-e2e5b486"]
availability_zones = ["eu-west-1a"]

cidr_blocks = ["0.0.0.0/0"]

#load_balancers = []

health_check_port = 8081
from_port   = 8080 
to_port     = 8081


hostname = "artifactory-1"

domain = "noon.com"

file_name = "artifactory.tpl"

ssl_certificate_id = "arn:aws:acm:eu-west-1:319584929632:certificate/bc1fe56f-dd73-468b-9ec6-bef9584b4f14"

archive_link = "https://git.fastfish.io/devops/config-management/repository/archive.zip?ref=master&private_token=WZXfUD9mUo8ayYLuYXCt"

health_check_type = "ELB"

min_size = 1

max_size = 3

total_instances = 1

monitoring = "false"

delete = "false"

// Define Tags Here
cluster_name = "Artifactory"

tag_product = "Artifactory-Environment"

tag_purpose = "Development and CI "

artifactory = {
  extra_user_data = ""
  key_name        = "test"
  ami             = "ami-00787074"
  instance_type   = "m4.4xlarge"
}


zone_id = "Z22EEM0L0IZX5Z"
dns_address = "artifactory.dev.fastfish.io"
record_type = "A" 
records = [""]                                                                                                                                                                                                                          
