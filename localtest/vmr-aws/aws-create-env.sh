#!/bin/bash

aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem
chmod 400 MyKeyPair.pem

aws ec2 create-security-group --group-name MySecurityGroup --description "My security group" >> aws-sc.txt

SG=$(cat aws-sc.txt|grep sg*|cut -c17-36)

rm aws-sc.txt

aws ec2 authorize-security-group-ingress \
    --group-id $SG \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 >> /dev/null

aws ec2 authorize-security-group-ingress \
    --group-id $SG \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0 >> /dev/null

aws ec2 authorize-security-group-ingress \
    --group-id $SG \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0 >> /dev/null

aws ec2 authorize-security-group-ingress \
    --group-id $SG \
    --protocol tcp \
    --port 8080 \
    --cidr 0.0.0.0/0 >> /dev/null

for i in vmr1-web1 vmr1-app1 vmr1-db1 vmr2-web1 vmr2-app1 vmr2-db1
do
    aws ec2 run-instances --image-id ami-04505e74c0741db8d --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids $SG \
            --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$i'}]' >> /dev/null
done