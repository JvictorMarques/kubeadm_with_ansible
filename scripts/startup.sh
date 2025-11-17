#!/bin/bash
cd terraform
terraform init
terraform apply -auto-approve
sleep 30;
cd ../ansible
ansible-playbook -i hosts.ini main.yml