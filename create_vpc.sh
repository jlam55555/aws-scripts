#!/bin/bash

VPC_CIDR=10.0.0.0/16
PUBLIC_CIDR=10.0.1.0/24
PRIVATE_CIDR=10.0.2.0/24
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR | jq '.Vpc.VpcId' | tr -d '"')

# create public subnet
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PUBLIC_CIDR | jq '.Subnet.SubnetId' | tr -d '"')

# create private subnet
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PRIVATE_CIDR | jq '.Subnet.SubnetId' | tr -d '"')

# create internet gateway
GATEWAY_ID=$(aws ec2 create-internet-gateway | jq '.InternetGateway.InternetGatewayId' | tr -d '"')

# attach gateway to the vpc
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $GATEWAY_ID

# create a custom route table for the VPC
ROUTETABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID | jq '.RouteTable.RouteTableId' | tr -d '"')

# create a custom route in the route table
aws ec2 create-route --route-table-id $ROUTETABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $GATEWAY_ID

# describe your routes
aws ec2 describe-route-tables --route-table-id $ROUTETABLE_ID

# describe your routes again
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query 'Subnets[*].{ID:SubnetId,CIDR:CidrBlock}'

# associate route table to subnet
aws ec2 associate-route-table  --subnet-id $PUBLIC_SUBNET_ID --route-table-id $ROUTETABLE_ID

# allow assigning public ip on launch
aws ec2 modify-subnet-attribute --subnet-id $PUBLIC_SUBNET_ID --map-public-ip-on-launch

echo "VPC_ID=$VPC_ID"
echo "PUBLIC_SUBNET_ID=$PUBLIC_SUBNET_ID"
echo "PRIVATE_SUBNET_ID=$PRIVATE_SUBNET_ID"
echo "GATEWAY_ID=$GATEWAY_ID"
echo "ROUTETABLE_ID=$ROUTETABLE_ID"
