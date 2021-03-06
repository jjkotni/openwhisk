#!/bin/bash
# Assuming current working directory is openwhisk home directory
export OPENWHISK_TMP_DIR=~/tmp

# Step1: Clean up current controller docker
cd ansible
ansible-playbook controller.yml -e mode=clean
cd ..
# Step2: Rebuild controller after making changes to source code
./gradlew :core:controller:distDocker -PdockerImageTag=nController

# Step3: Deploy the just created build. Check if using the same name causes issues!
cd ansible
ansible-playbook controller.yml -e docker_image_tag=nController -e docker_image_prefix=openwhisk -e docker_image_tag=nightly -e pid_mode=host
