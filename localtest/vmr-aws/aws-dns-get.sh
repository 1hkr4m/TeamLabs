#!/bin/bash
#aws ec2 describe-instances --region us-east-1 --query 'Reservations[].Instances[].PublicDnsName' --output text > aws-dns.txt

for j in 1 2
do
    echo "[env$j]" >> aws-dns.txt
    for i in vmr$j-web1 vmr$j-app1 vmr$j-db1
    do    
        echo "$i ansible_host=$(aws ec2 describe-instances --region us-east-1 --max-items 1 --filters "Name=tag:Name,Values=$i" --query 'Reservations[].Instances[].PublicDnsName' --output text)" >> aws-dns.txt
    done
    echo "" >> aws-dns.txt
done

cat >> aws-dns.txt <<EOF
[cluster:children]
env1
env2
EOF