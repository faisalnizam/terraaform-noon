# Launch Configuration Module

Create launch configuration that can be used by Amazon Auto Scaling Group.

## Variables

Some varaibles are directly passed to `aws_launch_configuration` and use the same name. Where this is the case, the description in the table below will be `[resource parameter]`

| Variable Name       | Description                              |
| :------------------ | ---------------------------------------- |
| `name`              | Will be used by `name_prefix` resource parameter |
| `image_id`          | `[resource parameter]`                   |
| `key_name`          | `[resource parameter]`                   |
| `instance_type`     | `[resource parameter]`                   |
| `security_groups`   | `[resource parameter]`                   |
| `enable_monitoring` | `[resource parameter]`                   |
| `user_data`         | `[resource parameter]`                   |
| `block_device`      | Create and attach a block device to the instance. See `Block Device` for details (type: `map`, default: `{ type: "none", delete_on_termination: true}`) |
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

| Name | Description                              |
| ---- | ---------------------------------------- |
| `id` | The ID of the created launch configuration |

## Examples

##### Instance with no block device

```Shell
module "lconf" {
  source            = "../launch_configuration"
  name              = "${var.name}"
  image_id          = "ami-9bf712f4"
  key_name          = "${var.key_name}"
  instance_type     = "${var.instance_type}"
  security_groups   = ["${var.security_groups}"]
  enable_monitoring = "${var.enable_monitoring}"
  user_data         = "${var.user_data}"
}
```

##### Instance with Ephemeral block device
```shell
module "lconf" {
  source            = "../launch_configuration"
  name              = "${var.name}"
  image_id          = "ami-9bf712f4"
  key_name          = "${var.key_name}"
  instance_type     = "${var.instance_type}"
  security_groups   = ["${var.security_groups}"]
  enable_monitoring = "${var.enable_monitoring}"
  user_data         = "${var.user_data}"
  block_device		= {
    	type: "ephemeral",
    	device_name: "/dev/xvda",
    	virtual_name: "ephemeral0"
  }
}
```

##### Instance with EBS block device
```shell
module "lconf" {
  source            = "../launch_configuration"
  name              = "${var.name}"
  image_id          = "ami-9bf712f4"
  key_name          = "${var.key_name}"
  instance_type     = "${var.instance_type}"
  security_groups   = ["${var.security_groups}"]
  enable_monitoring = "${var.enable_monitoring}"
  user_data         = "${var.user_data}"
  block_device	    = {
    	type: "ebs",
    	device_name: "/dev/xvda",
    	virtual_type: "gp2",
    	volume_size: "50",
    	delete_on_termination: false
  }
}
```
