#!/bin/sh

# --------------------------
# Install Base Applications
# --------------------------

hostname "artifactory-${index_value}"
yum update -y
yum install -y epel-release
yum install -y ansible-2.3.0.0 unzip
yum install -y vim
yum install -y wget
yum install -y telnet
yum install -y nmap

# -------------------------------
# Install Necessary Applications
# -------------------------------

yum install -y python-pip
pip install awscli
sudo yum install -y curl openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd


# ----------------------
# EBS Volume Attachment
# ----------------------

mkdir /data
INST_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
/usr/bin/aws ec2 attach-volume --volume-id ${ebs_volume_id} --instance-id $INST_ID --device /dev/xvdf --region eu-central-1


# ----------------------
# Ansible Part
# ----------------------

TMP_DIR=$(mktemp -d)
cd $TMP_DIR
#curl -o $TMP_DIR/ansible.zip '${archive_link}'
curl -o $TMP_DIR/ansible.zip "https://git.fastfish.io/devops/config-management/repository/archive.zip?ref=master&private_token=WZXfUD9mUo8ayYLuYXCt"
unzip ansible.zip
cd config-*/ansible
ansible-playbook -b -l localhost -i inventory/local.${env} playbooks/${playbook_name}.yml --connection=local
#rm -rf $TMP_DIR

# ---------------------------
# BootStrap Artifactory
# ---------------------------

#cd /tmp/
#wget https://bintray.com/jfrog/artifactory-rpms/rpm -O bintray-jfrog-artifactory-rpms.repo
#sudo mv bintray-jfrog-artifactory-rpms.repo /etc/yum.repos.d/
#sudo yum install -y jfrog-artifactory-oss
