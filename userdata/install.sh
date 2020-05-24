#! /bin/bash
sudo apt-get update -y

# Docker install
sudo apt-get install docker.io -y
sudo systemctl enable --now docker
sudo usermod -aG docker ubuntu
sudo pip install docker
sudo apt-get install python-yaml -y
sudo apt-get install docker-compose -y

# Ansible install
sudo apt-get install ansible -y

# Run Ansible playbook
cd /tmp/app
ansible-playbook playbook.yml
