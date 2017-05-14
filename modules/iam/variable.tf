variable "name" {}

variable "iam_policy" {
  default = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
            "Effect": "Deny",
            "Action": [
                "ec2:DescribeInstances"
            ],
            "Resource": [ "*" ]
        }
	]
}
EOF

  # non empty policy, to be able to add one later without rebooting a instance
}
