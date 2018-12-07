#!/bin/bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install -y docker-ce

curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

pip install awscli

DBPassword="$(aws ssm get-parameter --name /CloudFormation/Wordpress/DBPassword --with-decryption)"
sed -i "s/changeit/${DBPassword}/" /services/.env
cp -f /services/aws-bootstrap/docker-compose.yml /services/
docker-compose up -d
