terraform apply terraform.plan
./make_hostsfile.sh
ansible-playbook -i hosts --private-key ~/.ssh/dcos-eu-west1.pem playbooks/memsql_install.yaml
