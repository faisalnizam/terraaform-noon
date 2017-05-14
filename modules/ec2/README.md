# EC2 Module

Creates EC2 instance(s) which optionally can create and attach either EBS or Ephemeral block device (currently only a single block device).

## Variables

Some varaibles are directly passed to `aws_instance` and use the same name. Where this is the case, the description in the table below will be `[resource parameter]`

| Variable Name            | Description                              |
| :----------------------- | ---------------------------------------- |
| `role`                   | The role of the instance                 |
| `env`                    | The environment in which this instance exists in |
| `vpc`                    | The VPC this instance is attached to     |
| `orchestration`          | Will this instance be managed by orchestration (default: false) |
| `instance_type`          | `[resource parameter]`                   |
| `subnet_id`              | `[resource parameter]`                   |
| `ami_id`                 | The ID of the AMI to use                 |
| `number_of_instances`    | How many instances to create (default: 1) |
| `tags`                   | Additional tags to add to the instance (type: `map`, default: `{}`) |
| `aws_region`             | The AWS region used by the AWS provider  |
| `vpc_security_group_ids` | A list of security group ids that will be passed to `security_groups` parameter (type: `list`, default: `[]`) |
| `public_ip`              | The public IP address that will be passed to `associate_public_ip_address` parameter |
| `key_name`               | `[resource parameter]`                   |
| `availability_zone`      | `[resource parameter]`                   |
| `block_device`           | Create and attach a block device to the instance. See `Block Device` for details (type: `map`, default: `{ type: "none", delete_on_termination: true}`) |
### Block Device Map

| Key                     | Description                              |
| ----------------------- | ---------------------------------------- |
| `type`                  | Can be either `none` (default), `ebs` or `ephemeral` |
| `delete_on_termination` | `[resource parameter]` (default: false)  |
| `device_name`           | `[resource parameter]`                   |
| `virtual_name`          | `[resource parameter]`                   |
| `volume_type`           | `[resource parameter]`                   |
| `volume_size`           | `[resource parameter]`                   |

## Output

| Name              | Description                       |
| ----------------- | --------------------------------- |
| `ec2_instance_id` | The ID of the created EC instance |

## Examples

##### Instance with no block device

```shell
module "ec2" {
  source                      = "../../modules/ec2"
  ami_id                      = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  aws_region                  = "${var.region}"
  availability_zone           = "${var.availability_zone}"
  subnet_id                   = "${var.subnet_id}"
  number_of_instances         = "${var.count}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = "${module.custom_sg.default_sg}"
  role                        = "some_role"
  env                         = "${var.environment}"
  vpc                         = "${var.vpc}"
}
```

##### Instance with Ephemeral block device
```shell
module "ec2" {
  source                      = "../../modules/ec2"
  ami_id                      = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  aws_region                  = "${var.region}"
  availability_zone           = "${var.availability_zone}"
  subnet_id                   = "${var.subnet_id}"
  number_of_instances         = "${var.count}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = "${module.custom_sg.default_sg}"
  role                        = "some_role"
  env                         = "${var.environment}"
  vpc                         = "${var.vpc}"
  block_device				  = {
    	type: "ephemeral",
    	device_name: "/dev/xvda",
    	virtual_name: "ephemeral0"
  }
}
```

##### Instance with EBS block device
```shell
module "ec2" {
  source                      = "../../modules/ec2"
  ami_id                      = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  instance_name               = "${var.name}"
  aws_region                  = "${var.region}"
  availability_zone           = "${var.availability_zone}"
  subnet_id                   = "${var.subnet_id}"
  number_of_instances         = "${var.count}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = "${module.custom_sg.default_sg}"
  role                        = "some_role"
  env                         = "${var.environment}"
  vpc                         = "${var.vpc}"
  block_device				  = {
    	type: "ebs",
    	device_name: "/dev/xvda",
    	virtual_type: "gp2",
    	volume_size: "50",
    	delete_on_termination: false
  }
}
```
