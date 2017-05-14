output "role_date" {
  value = "${aws_iam_role.iam_role.create_date}"
}

output "role_id" {
  value = "${aws_iam_role.iam_role.unique_id}"
}

output "role_arn" {
  value = "${aws_iam_role.iam_role.arn}"
}

output "policy_id" {
  value = "${aws_iam_role_policy.iam_policy.id}"
}

output "policy_name" {
  value = "${aws_iam_role_policy.iam_policy.name}"
}

output "policy_doc" {
  value = "${aws_iam_role_policy.iam_policy.policy}"
}

output "policy_role" {
  value = "${aws_iam_role_policy.iam_policy.role}"
}

output "policy_profile" {
  value = "${aws_iam_role_policy.iam_policy.profile}"
}

output "profile_id" {
  value = "${aws_iam_instance_profile.iam_profile.id}"
}

output "profile_arn" {
  value = "${aws_iam_instance_profile.iam_profile.arn}"
}

output "profile_date" {
  value = "${aws_iam_instance_profile.iam_profile.create_date}"
}

output "profile_path" {
  value = "${aws_iam_instance_profile.iam_profile.path}"
}

output "profile_roles" {
  value = "${aws_iam_instance_profile.iam_profile.roles}"
}

output "profile_unique_id" {
  value = "${aws_iam_instance_profile.iam_profile.unique_id}"
}

output "profile_name" {
  value = "${aws_iam_instance_profile.iam_profile.name}"
}
