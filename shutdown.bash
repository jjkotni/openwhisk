#!/bin/bash
# Move to openwhisk src folder!
cd ansible
ansible-playbook openwhisk.yml -e mode=clean
ansible-playbook couchdb.yml -e mode=clean
ansible-playbook apigateway.yml -e mode=clean
