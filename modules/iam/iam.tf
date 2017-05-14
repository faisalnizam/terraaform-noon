resource "aws_iam_role" "iam_role" {
  name = "${replace(var.name,"/[^0-9A-Za-z_+=,.@-]/","-")}"

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Action": "sts:AssumeRole",
			"Principal": {
				"Service": "ec2.amazonaws.com"
			},
			"Effect": "Allow",
			"Sid": ""
		}
	]
}
EOF
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "${replace(var.name,"/[^0-9A-Za-z_+=,.@-]/","-")}"
  roles = ["${aws_iam_role.iam_role.name}"]
}

resource "aws_iam_role_policy" "iam_policy" {
  name = "${replace(var.name,"/[^0-9A-Za-z_+=,.@-]/","-")}"
  role = "${aws_iam_role.iam_role.id}"

  policy = "${var.iam_policy}"
}
