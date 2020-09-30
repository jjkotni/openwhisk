#!/bin/bash
# Assuming current working directory is openwhisk home directory
# Step1: Clean up current invoker docker
cd ansible
ansible-playbook invoker.yml -e mode=clean
cd ..
# Step2: Rebuild controller after making changes to source code
./gradlew :core:invoker:distDocker -PdockerImageTag=nInvoker
# Step3: Deploy the just created build. Check if using the same name causes issues!
cd ansible
ansible-playbook invoker.yml -e docker_image_tag=nInvoker
