#!/bin/sh

VPC_ID=$1
KEY_NAME=$2
PUBLIC_SUBNET_ID=$3

# create security group
GROUPNAME=sshaccess
GROUPID=$(aws ec2 create-security-group --group-name $GROUPNAME --description "Security group for SSH access" --vpc-id $VPC_ID | jq '.GroupId' | tr -d '"')

# add ssh to security group
aws ec2 authorize-security-group-ingress --group-id $GROUPID --protocol tcp --port 22 --cidr 0.0.0.0/0

# Linux 2 AMI instance type
IMAGE_TYPE=ami-03c5cc3d1425c6d34
INSTANCE_ID=$(aws ec2 run-instances --image-id ami-a4827dc9 --count 1 --instance-type t2.micro --key-name $KEY_NAME --security-group-ids $GROUPID --subnet-id $PUBLIC_SUBNET_ID | jq '.Instances[0].InstanceId' | tr -d '"')

aws ec2 describe-instances --instance-id $INSTANCE_ID

echo "GROUPID=$GROUPID"
echo "GROUPNAME=$GROUPNAME"
echo "INSTANCE_ID=$INSTANCE_ID"
