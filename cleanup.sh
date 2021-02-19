#!/bin/sh

EC2_INSTANCE_ID=$1
GROUP_ID=$2
PUBLIC_SUBNET_ID=$3
PRIVATE_SUBNET_ID=$4
ROUTETABLE_ID=$5
GATEWAY_ID=$6
VPC_ID=$7

# terminate EC2 instance
aws ec2 terminate-instances --instance-ids $EC2_INSTANCE_ID

# delete security group
aws ec2 delete-security-group --group-id $GROUP_ID

# delete subnets
aws ec2 delete-subnet --subnet-id $PUBLIC_SUBNET_ID
aws ec2 delete-subnet --subnet-id $PRIVATE_SUBNET_ID

# delete route table
aws ec2 delete-route-table --route-table-id $ROUTETABLE_ID

# detach internet gateway from vpc
aws ec2 detach-internet-gateway --internet-gateway-id $GATEWAY_ID --vpc-id $VPC_ID

# delete internet gateway
aws ec2 delete-internet-gateway --internet-gateway-id $GATEWAY_ID

# delete vpc
aws ec2 delete-vpc --vpc-id $VPC_ID
