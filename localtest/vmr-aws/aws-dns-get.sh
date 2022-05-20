#!/bin/bash
#aws ec2 describe-instances --region us-east-1 --query 'Reservations[].Instances[].PublicDnsName' --output text > aws-dns.txt

FILE_PATH=/home/aws-dns.txt

for j in 1 2
do
    echo "[env$j]" >> $FILE_PATH
    for i in vmr$j-web1 vmr$j-app1 vmr$j-db1
    do    
        echo "$i ansible_host=$(aws ec2 describe-instances --region us-east-1 --max-items 1 --filters "Name=tag:Name,Values=$i" --query 'Reservations[].Instances[].PublicDnsName' --output text)" >> $FILE_PATH
    done
    echo "" >> $FILE_PATH
done

cat >> $FILE_PATH <<EOF
[cluster:children]
env1
env2
EOF