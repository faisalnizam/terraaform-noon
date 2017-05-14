#!/bin/bash
#script to create an ansible hosts file based on output from terraform
#modified from Jan Repnak's version (mesosphere)
#twelcome@noon.com

function escape()
{
  local __resultvar=$1
  local result=`terraform output $1`
  result=$(printf '%s\n' "$result" | sed 's/^o://g;s,[\/&],\\&,g;s/$/\\/')
  result=${result%?}
  eval $__resultvar="'$result'"
}

# Create hosts file

hosts_src="./hosts.template"
hosts_dest="./hosts"

cp -R $hosts_src $hosts_dest

escape memsql_master_aggregator_public_ips
escape memsql_aggregator_public_ips
escape memsql_leaf_node_public_ips

sed -i '' "s/1.0.0.1/$memsql_master_aggregator_public_ips/g" $hosts_dest
sed -i '' "s/1.0.0.2/$memsql_aggregator_public_ips/g" $hosts_dest
sed -i '' "s/1.0.0.3/$memsql_leaf_node_public_ips/g" $hosts_dest
