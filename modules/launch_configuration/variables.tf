variable "name" {}
variable "image_id" {}
variable "key_name" {}
variable "instance_type" {}

variable "iam_policy" { 

default = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "ec2:DescribeInstances",
                  "ec2:AttachVolume",
                  "cloudwatch:ListMetrics",
                  "cloudwatch:GetMetricStatistics",
                  "ec2:DescribeVolumeAttribute",
                  "ec2:DescribeVolumeStatus",
                  "ec2:DescribeVolumes"
              ],
              "Resource": [ "*" ]
          }
      ]
}
EOF
}


 

variable "security_groups" {
  type    = "list"
  default = []
}

variable "enable_monitoring" {}
variable "user_data" {}

variable "block_device" {
  type = "map"

  default = {
    type                  = "none"
    delete_on_termination = true
  }
}
