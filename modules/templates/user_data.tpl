#!/bin/bash -v



# --------------------------
# Pre-Install dependencies
# --------------------------

yum install -y epel-release
yum install -y python-boto3



# --------------------------
# Set Fact and Tags
# --------------------------

export INST_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`
mkdir -p /etc/ansible/facts.d/

python - <<'EOF'
import os
import json
import urllib2
import collections

import boto3


ec2 = boto3.client('ec2', region_name="${region}")
def get_index():
    req = ec2.describe_instances(Filters=[
        {'Name': 'instance-state-name', 'Values': ['running']},
        {'Name': 'tag:Role', 'Values':["${role}"]}
    ])

    tags = {}
    indexs = collections.defaultdict(list)
    c_instance = None
    c_cluster = ""
    c_tags = {}
    concurrent_run = []
    for reservation in req["Reservations"]:
        for instance in reservation["Instances"]:
            tags = dict((t.get("Key", "").lower(), t.get("Value", "").lower()) for t in instance.get("Tags", []))
            cluster = "%s_%s_%s" %(tags.get("role", ""), tags.get("vpc", ""), tags.get("env", ""))
            if instance["InstanceId"] == os.environ["INST_ID"]:
                c_instance = instance["InstanceId"]
                c_cluster = cluster
                c_tags = tags
                if tags.get("index", "") != "":
                    return None, None, {}
            else:
                try:
                    indexs[cluster].append(int(tags.get("index", "NaN")))
                except ValueError:
                    concurrent_run.append(instance["InstanceId"])

    new_index = 1
    for index in sorted(indexs[c_cluster]):
        if index == new_index:
            new_index += 1
        else:
            break
    if len(concurrent_run) > 0:
        try:
            concurrent_run.append(c_instance)
            url = 'https://hooks.slack.com/services/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'
            values = {
                "username": "ConcurrentAWSDeployment",
                "color": "#ff9900",
                "text": "<!here>\n `%s` \ndid deploy concurrently, same Index may have been attributed \n Tags: \n `%s`\n"% (", ".join(concurrent_run), c_cluster),
                "icon_emoji": ":bangbang:",
                "channel": "#tech-devops-alerts"
            }
            req = urllib2.Request(url, json.dumps(values), {'Content-Type': 'application/json'})
            response = urllib2.urlopen(req)
            print("Concurrent run %s, slack: %s"%(" ".join(concurrent_run), response.read()))
        except urllib2.HTTPError as e:
            print('API Error: %s' % e.read())
        except Exception as e:
            print "%s" % e
    return new_index, c_instance, c_tags

next_index, current_instance, current_tags = get_index()
role = current_tags.get("role", "N/A")
vpc = current_tags.get("vpc", "N/A")
env = current_tags.get("env", "N/A")

if next_index and current_instance:
    ec2.create_tags(
        Resources=[
            current_instance
        ],
        Tags=[
            {'Key': 'Index', 'Value': "%d" % next_index},
            {'Key': 'Name', 'Value': "%s-%d.%s.%s" %(role, next_index, vpc, env)},
        ]
    )
with open("/etc/ansible/facts.d/aws_tags.fact", "w") as fact_file:
    fact_file.write(json.dumps({
        "VPC" : vpc,
        "Env" : env,
        "Index" : next_index,
        "Role" : role
    }))
EOF
index=$(grep Index /etc/ansible/facts.d/aws_tags.fact|cut -d ":" -f2|cut -d"," -f1)

# ----------------------
# Install Ansible dependencies
# ----------------------

yum update -y
yum install -y ansible-2.3.0.0 unzip awscli

# ----------------------
# EBS Volume Attachment
# ----------------------

if [ -n "${ebs_volumes}" ] ; then
# format  ebss_map=( ["1"]="ebs-xxxxxxx" ["2"]="ebs-xxxxxxx")
    declare -A ebss_map
    ebss_map=( ${ebs_volumes} )
    ebs=$${enis_map[$${index}]}
    /usr/bin/aws ec2 attach-volume --volume-id $${ebs} --instance-id $INST_ID --device /dev/xvdf --region eu-central-1
fi

# ----------------------
# Ansible run
# ----------------------

TMP_DIR=$(mktemp -d)
cd $TMP_DIR

curl -o $TMP_DIR/ansible.zip '${archive_link}'
unzip ansible.zip

cd config-*/ansible
ansible-playbook -b -l localhost -i inventory/local.${env} playbooks/${role}.yml --connection=local

rm -rf $TMP_DIR
