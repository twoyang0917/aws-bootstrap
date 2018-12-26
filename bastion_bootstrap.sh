#!/bin/bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install -y docker-ce

COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | tail -n 1`
curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

pip install awscli boto3 boto

apt-add-repository --yes ppa:ansible/ansible
apt-get update && apt-get install -y ansible

[ -d /services ] || mkdir /services
cd /services
cp -f aws-bootstrap/ansible/config/ec2.py /etc/ansible/ && chmod +x /etc/ansible/ec2.py
cp -f aws-bootstrap/ansible/config/ec2.ini /etc/ansible/
cp -f aws-bootstrap/ansible/config/ansible.cfg /etc/ansible/

chown -R ubuntu:ubuntu /services
usermod -aG docker ubuntu

ansible-playbook aws-bootstrap/ansible/playbooks/bastion.yml

