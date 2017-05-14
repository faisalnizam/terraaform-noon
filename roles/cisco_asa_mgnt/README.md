### Production Management Cisco Adaptive Security Virtual Appliance (ASAv)

The Adaptive Security Virtual Appliance brings full ASA firewall and VPN capabilities to virtualized environments to help safeguard traffic and multitenant architectures. Optimized for data center deployments, it’s designed to work in multiple hypervisor environments, reduce administrative overhead, and increase operational efficiency.

### Bug / Workaround

Due to a bug in Cisco ASAv AMI `ami-32c03f5d` (probably boot sequence), first deploy the instances then apply the `network_interface`

```
resource "aws_eip" "asava" {
  vpc               = true
  count             = 2
  network_interface = "${element(aws_network_interface.asava-public.*.id, count.index)}"
}

resource "aws_eip" "asavb" {
  vpc               = true
  count             = 2
  network_interface = "${element(aws_network_interface.asavb-public.*.id, count.index)}"
}

resource "aws_network_interface" "asava-public" {
  subnet_id         = "${element(split(",",var.public_subnet_ids),0)}"
  security_groups   = ["${aws_security_group.asav.id}"]
  source_dest_check = false
  count             = 2

  attachment {
    instance     = "${aws_instance.asava.id}"
    device_index = "${count.index + 1}"
  }

  tags {
    Name    = "${var.cluster_name}"
    cluster = "${var.cluster_name}"
    product = "${var.tag_product}"
    purpose = "${var.tag_purpose}"
    builder = "terraform_extreme"
  }
}

resource "aws_network_interface" "asavb-public" {
  subnet_id         = "${element(split(",",var.public_subnet_ids),1)}"
  security_groups   = ["${aws_security_group.asav.id}"]
  source_dest_check = false
  count             = 2

  attachment {
    instance     = "${aws_instance.asavb.id}"
    device_index = "${count.index + 1}"
  }

  tags {
    Name    = "${var.cluster_name}"
    cluster = "${var.cluster_name}"
    product = "${var.tag_product}"
    purpose = "${var.tag_purpose}"
    builder = "terraform_extreme"
  }
}
```

### Terraform Resources

![alt tag](map.png?raw=true "Resources")
