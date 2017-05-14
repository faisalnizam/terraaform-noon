### Business Intelligence cluster configuration: MemSQL

MemSQL cluster configuration.

Deployment  Steps:
=================

1. configure AWS keys and secrets in your environment or in the main.tf

2. run terraform plan -out terraform.plan

3. execute run.sh

 - this runs terraform apply, hosts file configuration and ansible-playbook
 
