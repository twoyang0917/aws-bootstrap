#!/bin/bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install -y docker-ce

curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

pip install awscli boto3

apt-add-repository --yes ppa:ansible/ansible
apt-get update && apt-get install -y ansible

cd /services
cp -f aws-bootstrap/ansible/ec2.py /etc/ansible/ && chmod +x /etc/ansible/ec2.py
cp -f aws-bootstrap/ansible/ec2.ini /etc/ansible/
cp -f aws-bootstrap/ansible/ansible.cfg /etc/ansible/
python /etc/ansible/ec2.py
