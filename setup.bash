#!/bin/bash
export OPENWHISK_TMP_DIR=/home/kjj/tmp
export WSK_CONFIG_FILE=/home/kjj/openwhisk/.wskprops
# Using virtualenv, python2.7 change ansible/environment/local/group_vars/all and add
# "ansible_python_interpreter: <Path to python interpreter>"
# Move to openwhisk source folder
# docker-compose install specific version [1.24.1 stable for now]
# npm, nodejs must be installed
#Free port for couchdb
sudo kill -9 $(sudo lsof -t -i:4369)

# Setup stuff, create db_local.ini
cd ansible
ansible-playbook setup.yml
# Make sure that db_host: 172.17.0.1 in db_local.ini
cd ..
./gradlew distDocker
cd ansible
# Create couchdb instance and initialize it
ansible-playbook couchdb.yml
ansible-playbook initdb.yml
ansible-playbook wipe.yml
# After this initialize openwhisk
ansible-playbook openwhisk.yml
# To install catalog of useful packages
# ansible-playbook postdeploy.yml
# To use API Gateway
ansible-playbook apigateway.yml
ansible-playbook routemgmt.yml

###################################################################################################
# Setup wsk cli for talking to this openwhisk instance
# [Assuming already present in ansible path of openwhisk source tree!]
wsk property set --apihost 172.17.0.1
wsk property set --auth `cat files/auth.guest`

#Create a pilot action
cd ..
wsk -i action create pilot pilot.py
